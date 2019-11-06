#...

echo 
echo 
echo ココからソフトインストール
echo 
echo 


if type "yum" /dev/null 2>&1; then

    sudo yum -y update
    sudo yum -y upgrade
    sudo yum -y install git vim tmux python3 gcc gcc-c++ python3 

elif type "apt" /dev/null 2>&1; then

    sudo apt -y update
    sudo apt -y upgrade
    sudo apt -y install git vim tmux python3 gcc gcc-c++ python3

fi

mkdir ~/.dotfiles

echo 
echo 
echo ココからシンボリックリンクのやつ
echo 
echo 

DOTPATH=~/.dotfiles
GITHUB_URL=https://github.com/tk7110g/dotfiles.git

# gitが使えるなら使う
if type "git" > /dev/null 2>&1; then
    git clone --recursive --depth 1 "$GITHUB_URL" "$DOTPATH"


# 使えないならcurlかwgetで
elif type "curl" /dev/null 2>&1 || type "wget" /dev/null 2>&1; then
    tarball="https://github.com/tk7110g/dotfiles/archive/master.tar.gz"

    if type "curl" /dev/null 2>&1; then
        curl -L "$tarball"

    elif type "wget" /dev/null 2>&1; then
        wget -O - "$tarball"

    fi | tar zxv

    # 解答したやつをDOTPATHにうつす
    mv -f dotfiles-master "$DOTPATH"

else
    die "curl or wget requred !!"
fi

cd ~/.dotfiles
if [ $? -ne 0 ]; then
    die "Not found: $DOTPATH"
fi

# シンボリックリンク
for f in .??*
do
    [ "$f" = ".git" ] && continue

    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done