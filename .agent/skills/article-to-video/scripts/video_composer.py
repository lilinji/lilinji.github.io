#!/usr/bin/env python3
"""
视频合成脚本 - 将图片序列合成为带字幕和音乐的视频

Usage:
    python video_composer.py --images-dir ./images --output video.mp4 --subtitles subtitles.srt --bgm bgm.mp3
"""

import argparse
import subprocess
import os
from pathlib import Path


def get_image_files(images_dir: str) -> list[str]:
    """获取目录下所有图片文件，按名称排序"""
    image_extensions = {'.png', '.jpg', '.jpeg', '.webp'}
    images = []
    for f in sorted(Path(images_dir).iterdir()):
        if f.suffix.lower() in image_extensions:
            images.append(str(f))
    return images


def create_image_list_file(images: list[str], durations: list[int], output_path: str) -> str:
    """创建ffmpeg concat demuxer所需的图片列表文件"""
    lines = []
    for i, (img, dur) in enumerate(zip(images, durations)):
        lines.append(f"file '{img}'")
        lines.append(f"duration {dur}")
    # 最后一帧需要重复
    if images:
        lines.append(f"file '{images[-1]}'")
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    
    return output_path


def compose_video_simple(
    images: list[str],
    durations: list[int],
    output: str,
    subtitles: str = None,
    bgm: str = None,
    resolution: tuple[int, int] = (1920, 1080),
    fps: int = 30
):
    """
    简单模式：使用concat合成视频（快速但无动效）
    """
    temp_dir = Path(output).parent
    video_no_audio = temp_dir / "temp_video_no_audio.mp4"
    
    # Step 1: 构建filter_complex
    filter_parts = []
    concat_inputs = []
    
    for i, (img, dur) in enumerate(zip(images, durations)):
        # 每张图片作为输入
        filter_parts.append(
            f"[{i}:v]scale={resolution[0]}:{resolution[1]}:force_original_aspect_ratio=decrease,"
            f"pad={resolution[0]}:{resolution[1]}:(ow-iw)/2:(oh-ih)/2,setsar=1,fps={fps}[v{i}]"
        )
        concat_inputs.append(f"[v{i}]")
    
    filter_parts.append(f"{''.join(concat_inputs)}concat=n={len(images)}:v=1:a=0,format=yuv420p[out]")
    filter_complex = ";".join(filter_parts)
    
    # 构建输入参数
    input_args = []
    for img, dur in zip(images, durations):
        input_args.extend(["-framerate", f"1/{dur}", "-i", img])
    
    # Step 1: 生成无音频视频
    cmd1 = [
        "ffmpeg", "-y",
        *input_args,
        "-filter_complex", filter_complex,
        "-map", "[out]",
        "-c:v", "libx264", "-preset", "fast", "-crf", "20",
        str(video_no_audio)
    ]
    
    print(f"[Step 1] 合成基础视频...")
    subprocess.run(cmd1, check=True)
    
    # Step 2: 添加字幕和音乐
    if subtitles or bgm:
        cmd2 = ["ffmpeg", "-y", "-i", str(video_no_audio)]
        
        if bgm:
            cmd2.extend(["-i", bgm])
        
        vf_filters = []
        if subtitles and Path(subtitles).exists():
            subtitle_style = (
                "FontName=Microsoft YaHei,FontSize=24,"
                "PrimaryColour=&Hffffff,OutlineColour=&H000000,"
                "Outline=2,Shadow=1,MarginV=40"
            )
            vf_filters.append(f"subtitles={subtitles}:force_style='{subtitle_style}'")
        
        if vf_filters:
            cmd2.extend(["-vf", ",".join(vf_filters)])
        
        cmd2.extend(["-c:v", "libx264", "-preset", "fast", "-crf", "20"])
        
        if bgm:
            cmd2.extend(["-c:a", "aac", "-b:a", "128k", "-shortest"])
        
        cmd2.append(output)
        
        print(f"[Step 2] 添加字幕和音乐...")
        subprocess.run(cmd2, check=True)
        
        # 清理临时文件
        video_no_audio.unlink(missing_ok=True)
    else:
        # 没有字幕和音乐，直接重命名
        video_no_audio.rename(output)
    
    print(f"[完成] 视频已保存: {output}")


def main():
    parser = argparse.ArgumentParser(description="视频合成工具")
    parser.add_argument("--images-dir", required=True, help="图片目录")
    parser.add_argument("--output", required=True, help="输出视频路径")
    parser.add_argument("--subtitles", help="字幕文件路径 (SRT格式)")
    parser.add_argument("--bgm", help="背景音乐路径")
    parser.add_argument("--durations", help="每张图片时长，逗号分隔，如: 15,20,25,20,20,15,20,15")
    parser.add_argument("--resolution", default="1920x1080", help="视频分辨率，如: 1920x1080")
    parser.add_argument("--fps", type=int, default=30, help="帧率")
    
    args = parser.parse_args()
    
    # 解析分辨率
    w, h = map(int, args.resolution.split('x'))
    
    # 获取图片
    images = get_image_files(args.images_dir)
    if not images:
        print(f"错误: 在 {args.images_dir} 中未找到图片")
        return 1
    
    print(f"找到 {len(images)} 张图片")
    
    # 解析时长
    if args.durations:
        durations = [int(d.strip()) for d in args.durations.split(',')]
    else:
        # 默认每张图片20秒
        durations = [20] * len(images)
    
    # 如果时长数量不够，用最后一个填充
    while len(durations) < len(images):
        durations.append(durations[-1] if durations else 20)
    
    # 合成视频
    compose_video_simple(
        images=images,
        durations=durations[:len(images)],
        output=args.output,
        subtitles=args.subtitles,
        bgm=args.bgm,
        resolution=(w, h),
        fps=args.fps
    )
    
    return 0


if __name__ == "__main__":
    exit(main())
