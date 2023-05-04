## shPomo

Simple pomodoro timer bash script.

## Usage

1.  Make sure to install these dependencies before running the script.

    **Ubuntu/Debian**

    `sudo apt-get install mpg123 libnotify-bin`

    **Arch Linux/Manjaro**

    `sudo pacman -S mpg123 libnotify`

    **Fedora**

    `sudo dnf install mpg123 libnotify`

    **openSUSE**

    `sudo zypper install mpg123 libnotify-tools`

2.  Specify sound file in the pomodoro.sh

    ```
    SOUND_FILE_PATH="/path/to/file.mp3"
    ```

3.  Run the shell script

    ```
    ./pomodoro.sh
    ```

    **Note:** Setting long break interval to 0 disables long breaks

