During my work I came across a curious issue. I have videos of adult-child interactions and I am interested in vocalizations of adults and children and turn-taking between them. I use the [DiViMe](https://github.com/srvk/DiViMe) tools to do the extraction of the relevant data, but this requires audio (not video) as input. Hence, I use [`ffmpeg`](https://www.ffmpeg.org/) to do the extraction and conversion of the audio stream. I realized that depending on the version of `ffmpeg` used, the DiViMe tools produce different results from the supposedly identical audio. In addition, during the tests that I describe here, it also became apparent that different video formats produce different results down the line. So, this repository is simply a record of this behaviour. Essentially, I start from one video ([where an adult male interacts with a child](https://www.youtube.com/watch?v=Yn8j4XRxSck)), download it in different video formats and then extract the audio from each video with different versions of `ffmpeg`. A summary of the results is below. 

Note that I did not upload any of the video and audio files and neither the ffmpeg binaries. If you are interested in the exact video (and/or) audio files, let me know. 

A summary of the procedure is in the pdf, but compiling it would require the source videos (and a working version of `avutils` R package), as would running the steps in `script.R`, which is the full code to produce the results here.

There are three take-home message from this exercise.

1) When the source for your audio is a video, it matters which version of `ffmpeg` you use to extract the audio. Somewhere between 3.3 and 4.2 there was a change.

2) The consequences of `ffmpeg` version seemingly work differently on different video formats, i.e. in the example here, only audio extracted from the `.avi` produced varying results.

3) And although consistent across different versions of `ffmpeg`, the different video formats produced different results (only `.flv` and `.mp4` produced identical results). In other words, even if you use a single version (the most recent?) of `ffmpeg`, it appears to matter in which file format your video is produces/saved.

To be clear, this is far from a comprehensive test (I only used one DiViMe tool and only one source video), but it suggests that this is likely an issue nevertheless.
