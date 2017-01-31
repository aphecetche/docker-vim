FROM alpine:3.5

RUN mkdir -p /root/.config/nvim/autoload \
 && mkdir -p /root/.config/ycm \
 && apk add --update clang git python ctags ncurses libxt libx11 libstdc++ nodejs \
 && apk add --virtual build-deps curl python-dev cmake build-base \
    make libxpm-dev libx11-dev libxt-dev ncurses-dev \
 && cd /tmp \
 && git clone --depth=1 https://github.com/vim/vim \
 && cd /tmp/vim \
 && ./configure --with-features=big \
                --enable-multibyte \
                --enable-pythoninterp \
                --with-python-config-dir=/usr/lib/python2.7/config \
                --disable-gui \
                --disable-netbeans \
                --prefix /usr \
 && make install \
 && rm -rf /tmp/vim \
 && cd /root/.config/nvim \
 && curl -O https://raw.githubusercontent.com/aphecetche/dotfiles/master/config/nvim/init.vim \
 && cd autoload \
 && curl -O https://raw.githubusercontent.com/aphecetche/dotfiles/master/config/nvim/autoload/plug.vim \
 && ln -s /root/.config/nvim/init.vim /root/.vimrc \
 && ln -s /root/.config/nvim /root/.vim \
 && vim --not-a-term -c "PlugInstall! | qall!" \
 && cd /root/.config/nvim/plugged/YouCompleteMe \
 && mkdir build \
 && cd build \
 && cmake ../third_party/ycmd/cpp/ -DEXTERNAL_LIBCLANG_PATH=/usr/lib/libclang.so.3.8 \
 && cmake --build . --target ycm_core \
 && cd /root/.config/nvim/plugged/YouCompleteMe \
 && rm -rf build \
 && apk del build-deps \
 && git clone --depth=1 https://github.com/chriskempson/base16-shell /root/base16-shell \
 && mv /root/.config/nvim/autoload/* /usr/share/vim/vim80/autoload \
 && mv /root/.config/nvim/plugged /usr/share/vim/ \
 && mv /root/.config/nvim/init.vim /usr/share/vim/vimrc \
 && sed -i 's_~/.config/nvim_/usr/share/vim/_g' /usr/share/vim/vimrc \
 && rm -rf /root/.vim* /root/.config \
 && npm install -g livedown

COPY vim.sh /usr/local/bin/vim.sh

ENTRYPOINT ["/usr/local/bin/vim.sh"]

