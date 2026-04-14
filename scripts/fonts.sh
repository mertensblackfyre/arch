# JETBrains
# Change to the Downloads directory
cd ~/Downloads

# Set the file name (without extension)
FONT_ZIP="JetBrainsMono.zip"
FONT_DIR="${FONT_ZIP%.zip}"  # Remove the .zip extension to get the folder name

# Download the JetBrainsMono font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/$FONT_ZIP

# Create a directory with the same name as the ZIP file (without the extension)
mkdir -p "$FONT_DIR"

# Unzip the font into the newly created directory
unzip "$FONT_ZIP" -d "$FONT_DIR"

# Move the font files to the system fonts directory
sudo mv "$FONT_DIR" /usr/share/fonts/

# Update font cache
sudo fc-cache -fv

