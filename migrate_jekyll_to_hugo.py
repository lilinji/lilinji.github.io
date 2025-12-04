#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Jekyll to Hugo PaperMod Migration Script

This script migrates Jekyll blog posts to Hugo PaperMod format:
- Converts front matter from Jekyll to Hugo format
- Updates image paths from absolute to relative
- Copies images to post directories
- Creates Hugo-compatible directory structure
"""

import os
import re
import shutil
from pathlib import Path
from datetime import datetime
import yaml


class JekyllToHugoMigrator:
    def __init__(self, source_dir, target_dir, img_dir):
        """
        Initialize the migrator.
        
        Args:
            source_dir: Jekyll _posts directory
            target_dir: Hugo content/posts directory
            img_dir: Jekyll img/posts directory
        """
        self.source_dir = Path(source_dir)
        self.target_dir = Path(target_dir)
        self.img_dir = Path(img_dir)
        self.stats = {
            'total': 0,
            'success': 0,
            'failed': 0,
            'images_copied': 0
        }
        
    def extract_date_from_filename(self, filename):
        """Extract date from Jekyll filename format: YYYY-MM-DD-title.md"""
        match = re.match(r'(\d{4}-\d{2}-\d{2})-(.+)\.md$', filename)
        if match:
            date_str = match.group(1)
            title_slug = match.group(2)
            return date_str, title_slug
        return None, None
    
    def parse_jekyll_front_matter(self, content):
        """Parse Jekyll front matter and content."""
        # Match front matter between --- markers
        match = re.match(r'^---\s*\n(.*?)\n---\s*\n(.*)$', content, re.DOTALL)
        if not match:
            return None, content
        
        front_matter_str = match.group(1)
        body = match.group(2)
        
        try:
            front_matter = yaml.safe_load(front_matter_str)
            return front_matter, body
        except yaml.YAMLError as e:
            print(f"  ⚠️  YAML parsing error: {e}")
            return None, content
    
    def convert_front_matter(self, jekyll_fm, date_str, title_slug):
        """Convert Jekyll front matter to Hugo format."""
        hugo_fm = {}
        
        # Title (required)
        hugo_fm['title'] = jekyll_fm.get('title', title_slug.replace('-', ' ').title())
        
        # Date (from filename)
        hugo_fm['date'] = f"{date_str}T00:00:00+08:00"
        
        # Draft status
        hugo_fm['draft'] = False
        
        # Tags
        if 'tags' in jekyll_fm:
            tags = jekyll_fm['tags']
            if isinstance(tags, list):
                hugo_fm['tags'] = tags
            elif isinstance(tags, str):
                hugo_fm['tags'] = [tags]
        
        # Description (from subtitle if available)
        if 'subtitle' in jekyll_fm:
            hugo_fm['description'] = jekyll_fm['subtitle']
        
        # Author
        hugo_fm['author'] = "Ringi Lee"
        
        # Table of Contents
        if jekyll_fm.get('catalog', False):
            hugo_fm['showToc'] = True
            hugo_fm['tocOpen'] = False
        
        return hugo_fm
    
    def find_images_in_content(self, content, title_slug):
        """Find all image references in markdown content."""
        # Pattern: ![alt text](/img/posts/article-name/image.jpg)
        pattern = r'!\[([^\]]*)\]\(/img/posts/([^/]+)/([^)]+)\)'
        matches = re.findall(pattern, content)
        
        images = []
        for alt_text, article_dir, image_name in matches:
            images.append({
                'alt': alt_text,
                'article_dir': article_dir,
                'image_name': image_name,
                'original_path': f'/img/posts/{article_dir}/{image_name}'
            })
        
        return images
    
    def update_image_paths(self, content):
        """Update image paths from absolute to relative."""
        # Replace /img/posts/article-name/image.jpg with image.jpg
        pattern = r'!\[([^\]]*)\]\(/img/posts/[^/]+/([^)]+)\)'
        replacement = r'![\1](\2)'
        updated_content = re.sub(pattern, replacement, content)
        
        return updated_content
    
    def copy_images(self, images, post_dir):
        """Copy images from img/posts to post directory."""
        copied = 0
        
        for img in images:
            # Source path
            src_path = self.img_dir / img['article_dir'] / img['image_name']
            
            # Destination path
            dst_path = post_dir / img['image_name']
            
            # Copy if source exists
            if src_path.exists():
                try:
                    shutil.copy2(src_path, dst_path)
                    copied += 1
                    print(f"    📷 Copied: {img['image_name']}")
                except Exception as e:
                    print(f"    ⚠️  Failed to copy {img['image_name']}: {e}")
            else:
                print(f"    ⚠️  Image not found: {src_path}")
        
        return copied
    
    def migrate_post(self, post_file):
        """Migrate a single Jekyll post to Hugo format."""
        filename = post_file.name
        print(f"\n📝 Processing: {filename}")
        
        # Extract date and title from filename
        date_str, title_slug = self.extract_date_from_filename(filename)
        if not date_str:
            print(f"  ❌ Invalid filename format: {filename}")
            return False
        
        # Read source file
        try:
            with open(post_file, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"  ❌ Failed to read file: {e}")
            return False
        
        # Parse front matter
        jekyll_fm, body = self.parse_jekyll_front_matter(content)
        if jekyll_fm is None:
            print(f"  ❌ Failed to parse front matter")
            return False
        
        # Convert front matter
        hugo_fm = self.convert_front_matter(jekyll_fm, date_str, title_slug)
        
        # Find images in content
        images = self.find_images_in_content(body, title_slug)
        if images:
            print(f"  🖼️  Found {len(images)} image(s)")
        
        # Update image paths
        updated_body = self.update_image_paths(body)
        
        # Create target directory
        post_dir = self.target_dir / f"{date_str}-{title_slug}"
        post_dir.mkdir(parents=True, exist_ok=True)
        
        # Write Hugo post
        hugo_content = "---\n"
        hugo_content += yaml.dump(hugo_fm, allow_unicode=True, sort_keys=False)
        hugo_content += "---\n"
        hugo_content += updated_body
        
        target_file = post_dir / "index.md"
        try:
            with open(target_file, 'w', encoding='utf-8') as f:
                f.write(hugo_content)
            print(f"  ✅ Created: {target_file.relative_to(self.target_dir.parent)}")
        except Exception as e:
            print(f"  ❌ Failed to write file: {e}")
            return False
        
        # Copy images
        if images:
            copied = self.copy_images(images, post_dir)
            self.stats['images_copied'] += copied
        
        return True
    
    def migrate_all(self):
        """Migrate all Jekyll posts."""
        print("=" * 70)
        print("Jekyll to Hugo PaperMod Migration")
        print("=" * 70)
        print(f"Source: {self.source_dir}")
        print(f"Target: {self.target_dir}")
        print(f"Images: {self.img_dir}")
        print("=" * 70)
        
        # Get all markdown files
        post_files = sorted(self.source_dir.glob("*.md"))
        self.stats['total'] = len(post_files)
        
        print(f"\nFound {self.stats['total']} posts to migrate\n")
        
        # Migrate each post
        for post_file in post_files:
            if self.migrate_post(post_file):
                self.stats['success'] += 1
            else:
                self.stats['failed'] += 1
        
        # Print summary
        self.print_summary()
    
    def print_summary(self):
        """Print migration summary."""
        print("\n" + "=" * 70)
        print("Migration Summary")
        print("=" * 70)
        print(f"Total posts:      {self.stats['total']}")
        print(f"✅ Successful:    {self.stats['success']}")
        print(f"❌ Failed:        {self.stats['failed']}")
        print(f"📷 Images copied: {self.stats['images_copied']}")
        print("=" * 70)
        
        if self.stats['success'] > 0:
            print("\n✨ Migration completed!")
            print(f"\nNext steps:")
            print(f"1. Review migrated posts in: {self.target_dir}")
            print(f"2. Run: hugo server -D")
            print(f"3. Visit: http://localhost:1313")
        

def main():
    """Main entry point."""
    # Paths
    source_dir = r"D:\lilinji.github.io\lilinji.github.io-master\_posts"
    target_dir = r"D:\lilinji.github.io\content\posts"
    img_dir = r"D:\lilinji.github.io\lilinji.github.io-master\img\posts"
    
    # Create migrator
    migrator = JekyllToHugoMigrator(source_dir, target_dir, img_dir)
    
    # Run migration
    migrator.migrate_all()


if __name__ == "__main__":
    main()
