# Copy the packaged project into the Pixel Streaming runtime image
FROM ghcr.io/epicgames/unreal-engine:runtime-pixel-streaming

# Switch to root user to install packages
USER root

# Install AWS CLI
RUN apt-get update && apt-get install -y awscli

# Set the AWS region (optional, can also be set via environment variables or AWS CLI config)
ENV AWS_DEFAULT_REGION=ap-northeast-3

# Copy the project from S3 bucket
RUN aws s3 cp --recursive s3://sugarstore/Sugar_LinuxTick /home/ue4/project

# Change the script's permissions to ensure it is executable
RUN chmod +x /home/ue4/project/C2004_Sugar_Tower.sh

# Set the project as the container's entrypoint
ENTRYPOINT ["/home/ue4/project/C2004_Sugar_Tower.sh", "-RenderOffscreen", "-AllowPixelStreamingCommands" ,"-PixelStreamingHideCursor" ,"-PixelStreamingWebRTCMaxFps=30", "-PixelStreamingWebRTCDisableReceiveAudio","-FullStdOutLogOutput", "-ForceRes", "-ResX=1920", "-ResY=1080"]
