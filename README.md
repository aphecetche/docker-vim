Base image of vim 8.0 with a bunch of plugins, in particular YouCompleteMe configured for C++

Not the smallest image in the world, but the intent was to get it working first. And then ... we'll see some other day
if we can make it smaller... or not ;-)

That's a personal image, there is absolutely no guarantee it will work for you.

Note by the way that I'm only using it as a base image, I'm basically deriving one from it with a given user embedded :

```
FROM aphecetche/alpine-vim-ycm

ARG userName=unknown
ARG userGroup=unknown
ARG userId=1234
ARG userGroupId=1234

RUN (getent group $userGroupId) 2>&1 > /dev/null && delgroup $(getent group $userGroupId | cut -d ':' -f 1) || echo "no
conflicting gr
oup id to delete" \
; delgroup $userGroup 2>&1 > /dev/null || echo "no conflicting group name to delete" \
; addgroup -S -g $userGroupId $userGroup && adduser -H -D -u $userId -G $userGroup $userName \
; chown -R $userName:$userGroup /usr/share/vim

USER $userName

ENTRYPOINT ["/usr/local/bin/vim.sh"]
```

and it's built using : 

```
userName=$(whoami)
userGroup=$(id -gn $userName)
userGroupId=$(id -g $userName)

cd ~/dotfiles/config/dvim

docker build -f Dockerfile -t dvim-$userName --pull . \
--build-arg userName=$userName \
--build-arg userId=$UID \
--build-arg userGroupId=$userGroupId \
--build-arg userGroup=$userGroup
``` 

That way the volumes mounted (using `-v src:dest` docker syntax) will have the correct ownership on my host...

