# Copy the packaged project into the Pixel Streaming runtime image
FROM ghcr.io/epicgames/unreal-engine:runtime-pixel-streaming

# Switch to root user to install packages and set up the environment
USER root

# Install AWS CLI
RUN apt-get update && apt-get install -y awscli

# Create a directory for the project
RUN mkdir -p /home/ue4/project

# Copy the project from S3 bucket
RUN aws s3 cp --recursive s3://sugarstore/T2313Linux_Tick /home/ue4/project

# Create a non-root user 'ue4user' and give ownership of the project directory
RUN useradd -m ue4user && \
    chown -R ue4user:ue4user /home/ue4

# Change the script's permissions to ensure it is executable
RUN chmod +x /home/ue4/project/T2313.sh

# Switch to the non-root user
USER ue4user

# Set the project as the container's entrypoint
ENTRYPOINT ["/home/ue4/project/T2313.sh", "-RenderOffscreen", "-AllowPixelStreamingCommands" ,"-PixelStreamingHideCursor" ,"-PixelStreamingWebRTCMaxFps=30", "-PixelStreamingWebRTCDisableReceiveAudio","-FullStdOutLogOutput", "-ForceRes", "-ResX=1920", "-ResY=1080"]