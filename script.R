library(avutils)
set_binaries(pathtosox = "/usr/local/bin/sox", printmessages = FALSE)
test_binaries()

# set paths to ffmpeg binaries (not on github!)
f2 <- normalizePath("ffmpeg2.8.5/ffmpeg")
f3 <- normalizePath("ffmpeg3.3/ffmpeg")
f4 <- normalizePath("ffmpeg4.2/ffmpeg")
# check versions
system2(command = f2, args = "-version")
system2(command = f3, args = "-version")
system2(command = f4, args = "-version")


if (!dir.exists("tempaudio")) dir.create("tempaudio")

mediasource <- list.files(path = "testvideo/", full.names = TRUE)

outname <- function(inname, ffmpegvers) {
  if (ffmpegvers == 2) res <- paste0("tempaudio/ffmpeg2_", file_path_sans_ext(basename(inname)), ".wav")
  if (ffmpegvers == 3) res <- paste0("tempaudio/ffmpeg3_", file_path_sans_ext(basename(inname)), ".wav")
  if (ffmpegvers == 4) res <- paste0("tempaudio/ffmpeg4_", file_path_sans_ext(basename(inname)), ".wav")
  res
}

for (i in mediasource) {
  for (f in 2:4) {
    cmarg <- paste("-i", shQuote(i), "-y -ar 44100 -ac 1", shQuote(outname(i, ffmpegvers = f)), "-hide_banner")
    if (f == 2) system2(command = f2, args = cmarg)
    if (f == 3) system2(command = f3, args = cmarg)
    if (f == 4) system2(command = f4, args = cmarg)
  }
}


x <- audio_info(list.files("tempaudio", full.names = TRUE))
x$filename <- basename(as.character(x$filename))

x[grep("AVI", x$filename), ]
x[grep("FLV", x$filename),]
x[grep("MP4", x$filename),]
x[grep("WMV", x$filename),]

# run Marvin's yunitator
# takes about 5 minutes
divime_talkertype(audio_loc = "tempaudio", divime_loc = "/Volumes/Data/VM2/ooo/DiViMe/", marvinator = TRUE)


# copy rttm output files to their own folder
if (!dir.exists("rttmfiles")) dir.create("rttmfiles")

from <- list.files(".", pattern = ".rttm$", recursive = TRUE)
to <- file.path("rttmfiles", basename(from))
file.copy(from = from, to = to)

res <- expand.grid(vid = c("AVI", "FLV", "MP4", "WMV"), ffmpeg = paste0("ffmpeg", 2:4), role = c("CHI", "MAL", "FEM"))
res$dur <- NA
res$n_anno <- NA
# read files by source video
for (i in 1:nrow(res)) {
  x <- to[grepl(pattern = res$vid[i], x = to)]
  x <- x[grepl(pattern = res$ffmpeg[i], x = x)]
  x <- read_rttm(x)
  x <- x[x$tier == as.character(res$role[i]), ]
  res$n_anno[i] <- nrow(x)
  res$dur[i] <- sum(x$duration)
}




# as there is little FEM recognized, I'll skip that (in fact, the video is MAL-CHI)

par(mfrow = c(1, 2), family = "serif")
pdata <- res[res$role == "CHI", ]
pdata$x <- rep(1:3, each = 4)# + runif(n = 12, -0.05, 0.05)
pdata$sym <- rep(0:3, 3)

plot(0, 0, xlim = c(0.5, 3.5), ylim = c(0, 80), las = 1, axes = FALSE, 
     xlab = "audio extraction from video with", ylab = "cum. duration of annotations", main = "CHI", cex.lab = 0.85)
axis(1, at = 1:3, labels = levels(pdata$ffmpeg), lwd = 0)
axis(2, las = 1)
box()
points(pdata$x, pdata$dur, pch = pdata$sym)
legend("top", ncol = 4, legend = levels(pdata$vid), yjust = 1, xpd = TRUE, pch = 0:3, cex = 0.7)


pdata <- res[res$role == "MAL", ]
pdata$x <- rep(1:3, each = 4)# + runif(n = 12, -0.1, 0.1)
pdata$sym <- rep(0:3, 3)

plot(0, 0, xlim = c(0.5, 3.5), ylim = c(0, 80), las = 1, axes = FALSE, 
     xlab = "audio extraction from video with", ylab = "cum. duration of annotations", main = "MAL", cex.lab = 0.85)
axis(1, at = 1:3, labels = levels(pdata$ffmpeg), lwd = 0)
axis(2, las = 1)
box()
points(pdata$x, pdata$dur, pch = pdata$sym)
legend("top", ncol = 4, legend = levels(pdata$vid), yjust = 1, xpd = TRUE, pch = 0:3, cex = 0.7)



par(mfrow = c(1, 2), family = "serif")
pdata <- res[res$role == "CHI", ]
pdata$x <- rep(1:3, each = 4)# + runif(n = 12, -0.05, 0.05)
pdata$sym <- rep(0:3, 3)

plot(0, 0, xlim = c(0.5, 3.5), ylim = c(0, 60), las = 1, axes = FALSE,
     xlab = "audio extraction from video with", ylab = "annotation count", main = "CHI", cex.lab = 0.85)
axis(1, at = 1:3, labels = levels(pdata$ffmpeg), lwd = 0)
axis(2, las = 1)
box()
points(pdata$x, pdata$n_anno, pch = pdata$sym)
legend("top", ncol = 4, legend = levels(pdata$vid), yjust = 1, xpd = TRUE, pch = 0:3, cex = 0.7)


pdata <- res[res$role == "MAL", ]
pdata$x <- rep(1:3, each = 4)# + runif(n = 12, -0.1, 0.1)
pdata$sym <- rep(0:3, 3)

plot(0, 0, xlim = c(0.5, 3.5), ylim = c(0, 40), las = 1, axes = FALSE,
     xlab = "audio extraction from video with", ylab = "annotation count", main = "MAL", cex.lab = 0.85)
axis(1, at = 1:3, labels = levels(pdata$ffmpeg), lwd = 0)
axis(2, las = 1)
box()
points(pdata$x, pdata$n_anno, pch = pdata$sym)
legend("top", ncol = 4, legend = levels(pdata$vid), yjust = 1, xpd = TRUE, pch = 0:3, cex = 0.7)
