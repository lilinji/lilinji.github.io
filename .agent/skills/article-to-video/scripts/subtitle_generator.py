#!/usr/bin/env python3
"""
字幕生成器 - 根据脚本生成SRT格式字幕文件

Usage:
    python subtitle_generator.py --script script.json --output subtitles.srt
"""

import argparse
import json
from pathlib import Path


def format_timestamp(seconds: float) -> str:
    """将秒数转换为SRT时间戳格式 HH:MM:SS,mmm"""
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    millis = int((seconds % 1) * 1000)
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{millis:03d}"


def generate_srt(scenes: list[dict], output_path: str) -> None:
    """
    根据场景列表生成SRT字幕文件
    
    scenes格式:
    [
        {"start": 0, "end": 15, "text": "字幕内容"},
        {"start": 15, "end": 35, "text": "第二段字幕"},
        ...
    ]
    """
    lines = []
    for i, scene in enumerate(scenes, 1):
        start = format_timestamp(scene["start"])
        end = format_timestamp(scene["end"])
        text = scene["text"]
        
        lines.append(str(i))
        lines.append(f"{start} --> {end}")
        lines.append(text)
        lines.append("")  # 空行分隔
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    
    print(f"字幕已保存: {output_path}")


def parse_script_markdown(script_path: str) -> list[dict]:
    """
    解析Markdown格式的脚本文件
    
    格式示例:
    ## 0:00-0:15 开场
    字幕内容第一行
    字幕内容第二行
    
    ## 0:15-0:35 场景一
    字幕内容...
    """
    scenes = []
    current_scene = None
    
    with open(script_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if line.startswith('## '):
                # 解析时间和标题
                # 格式: ## 0:00-0:15 标题
                parts = line[3:].split(' ', 1)
                if '-' in parts[0]:
                    time_range = parts[0]
                    start_str, end_str = time_range.split('-')
                    
                    def parse_time(t):
                        parts = t.split(':')
                        if len(parts) == 2:
                            return int(parts[0]) * 60 + int(parts[1])
                        elif len(parts) == 3:
                            return int(parts[0]) * 3600 + int(parts[1]) * 60 + int(parts[2])
                        return 0
                    
                    if current_scene:
                        scenes.append(current_scene)
                    
                    current_scene = {
                        "start": parse_time(start_str),
                        "end": parse_time(end_str),
                        "text": ""
                    }
            elif current_scene and line:
                if current_scene["text"]:
                    current_scene["text"] += "\n" + line
                else:
                    current_scene["text"] = line
    
    if current_scene:
        scenes.append(current_scene)
    
    return scenes


def main():
    parser = argparse.ArgumentParser(description="字幕生成器")
    parser.add_argument("--script", required=True, help="脚本文件路径 (JSON或Markdown)")
    parser.add_argument("--output", required=True, help="输出SRT文件路径")
    
    args = parser.parse_args()
    
    script_path = Path(args.script)
    
    if script_path.suffix == '.json':
        with open(script_path, 'r', encoding='utf-8') as f:
            scenes = json.load(f)
    elif script_path.suffix in ['.md', '.markdown']:
        scenes = parse_script_markdown(str(script_path))
    else:
        print(f"不支持的脚本格式: {script_path.suffix}")
        return 1
    
    generate_srt(scenes, args.output)
    return 0


if __name__ == "__main__":
    exit(main())
