function virtualenv_prompt_info2(){
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo "${ZSH_THEME_VIRTUALENV_PREFIX2:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=] }"
}

function user_color(){
  # Highlight the user name when logged in as root.
  if [[ "${USER}" == "root" ]]; then
    echo %{$fg[red]%};
  else
    echo %{$fg[blue]%};
  fi;
}

function docker_prompt_context(){
  DOCKER_CONTEXT=$(docker context show 2> /dev/null || echo default )
  if [[ "${DOCKER_CONTEXT}" != "default" ]]; then
    echo "%{$fg_bold[blue]%}🐳:(%{$fg_bold[red]%}${DOCKER_CONTEXT}%{$fg_bold[blue]%}) ";
  fi;
}

#local virtual_env_status="%([ -z ${VIRTUAL_ENV+x} ]::(`basename \"$VIRTUAL_ENV\"`) )"
local ret_status="%(?:%{$fg_bold[green]%}λ :%{$fg_bold[red]%}λ )"
PROMPT='
$(user_color)%n%{$fg[cyan]%}@%{$fg[magenta]%}%M %{$fg[green]%}%d%{$reset_color%} $(docker_prompt_context)$(git_prompt_info)
%{$fg[yellow]%}$(virtualenv_prompt_info2)${ret_status}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
