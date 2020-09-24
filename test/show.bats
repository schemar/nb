#!/usr/bin/env bats

load test_helper

# `show` ######################################################################

@test "\`show\` with no argument exits with status 1 and prints help." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1              ]]
  [[ "${lines[0]}" =~ Usage\:     ]]
  [[ "${lines[1]}" =~ '  nb show' ]]
}

@test "\`show\` with no argument does not show the note file." {
  skip "TODO: Determine how to test for \`\$PAGER\`."
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
}

# `show --dump` ###############################################################

@test "\`show --dump\` with argument exits with 0 and prints note with highlighting." {
  {
    run "${_NB}" init
    run "${_NB}" add "# Example"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ ! "${lines[0]}" =~ "# Example" ]]
  [[ "${lines[0]}" =~ "Example"     ]]
}

@test "\`show --dump --no-color\` with argument exits with 0 and prints note without highlighting." {
  {
    run "${_NB}" init
    run "${_NB}" add "# Example"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --dump --no-color

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${lines[0]}" =~ "# Example" ]]
}

@test "\`show --dump\` with no argument exits with 1 and prints help." {
  {
    run "${_NB}" init
    run "${_NB}" add "# Example"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1              ]]
  [[ ! "${output}" =~ mock_editor ]]
  [[ "${lines[0]}" =~ Usage\:     ]]
  [[ "${lines[1]}" =~ '  nb show' ]]

}

# <selector> ##################################################################

@test "\`show <selector>\` with empty repo exits with 1 and prints help." {
  {
    run "${_NB}" init
  }

  run "${_NB}" show 1

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1                                                            ]]
  [[ "${lines[0]}" == "${_ERROR_PREFIX} Note not found: $(_color_primary "1")"  ]]
}

# `show <filename> --dump` ####################################################

@test "\`show <filename> --dump\` exits with status 0 and dumps note file." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${_filename}" --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0            ]]
  [[ "${output}" =~ mock_editor ]]
}

# `show <id> --dump` ##########################################################

@test "\`show <id> --dump\` exits with status 0 and dumps note file." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --dump

  printf "\${_filename}: %s\\n" "${_filename}"
  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0            ]]
  [[ "${output}" =~ mock_editor ]]
}

# `show <path> --dump` #######################################################

@test "\`show <path> --dump\` exits with status 0 and dumps note file." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${_NOTEBOOK_PATH}/${_filename}" --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0            ]]
  [[ "${output}" =~ mock_editor ]]
}

# `show <title> --dump` #######################################################

@test "\`show <title> --dump\` exits with status 0 and dumps note file." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }
  _title="$(head -1 "${_NOTEBOOK_PATH}/${_filename}" | sed 's/^\# //')"

  run "${_NB}" show "${_title}" --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0            ]]
  [[ "${output}" =~ mock_editor ]]
}

# `show <filename> --path` ####################################################

@test "\`show <filename> --path\` exits with status 0 and prints note path." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${_filename}" --path

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                                  ]]
  [[ "${output}" == "${_NOTEBOOK_PATH}/${_filename}"  ]]
}

# `show <id> --path` ##########################################################

@test "\`show <id> --path\` exits with status 0 and prints note path." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --path

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                                  ]]
  [[ "${output}" == "${_NOTEBOOK_PATH}/${_filename}"  ]]
}


# `show <path> --path` #######################################################

@test "\`show <path> --path\` exits with status 0 and prints note path." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${_NOTEBOOK_PATH}/${_filename}" --path

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                                  ]]
  [[ "${output}" == "${_NOTEBOOK_PATH}/${_filename}"  ]]
}

# `show <title> --path` #######################################################

@test "\`show <title> --path\` exits with status 0 and prints note path." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
    _title="$(head -1 "${_NOTEBOOK_PATH}/${_filename}" | sed 's/^\# //')"
  }

  run "${_NB}" show "${_title}" --path

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                                  ]]
  [[ "${output}" == "${_NOTEBOOK_PATH}/${_filename}"  ]]
}

# `show <filename> --id` ######################################################

@test "\`show <filename> --id\` exits with status 0 and prints note id." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${_filename}" --id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" == "1" ]]
}

# `show <id> --id` ############################################################

@test "\`show <id> --id\` exits with status 0 and prints note id." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" == "1" ]]
}

# `show <path> --id` ##########################################################

@test "\`show <path> --id\` exits with status 0 and prints note id." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show "${_NOTEBOOK_PATH}/${_filename}" --id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" == "1" ]]
}

# `show <title> --id` #########################################################

@test "\`show <title> --id\` exits with status 0 and prints note id." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
    _title="$(head -1 "${_NOTEBOOK_PATH}/${_filename}" | sed 's/^\# //')"
  }

  run "${_NB}" show "${_NOTEBOOK_PATH}/${_filename}" --id

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0    ]]
  [[ "${output}" == "1" ]]
}

# encrypted ###################################################################

@test "\`show\` with encrypted file show properly without errors." {
  {
    run "${_NB}" init
    run "${_NB}" add "# Content" --encrypt --password=example

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --password=example --dump

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  # Returns status 0
  [[ ${status} -eq 0 ]]

  # Prints file content
  [[ "${output}" =~ Content ]]
}

# `show <id> --filename` ######################################################

@test "\`show <id> --filename\` exits with status 0 and prints note filename." {
  {
    run "${_NB}" init
    run "${_NB}" add "example.md"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

@test "\`show <id> --basename\` exits with status 0 and prints note filename." {
  {
    run "${_NB}" init
    run "${_NB}" add "example.md"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --basename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

# `show <id> --title` #########################################################

@test "\`show <id> --title\` exits with status 0 and prints note filename." {
  {
    run "${_NB}" init
    run "${_NB}" add "example.md" --title "Example Title"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --title

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ "${output}" == "Example Title" ]]
}

# `show <id> --info` ##########################################################

@test "\`show <id> --info\` exits with status 0 and prints unscoped note info." {
  {
    run "${_NB}" init
    run "${_NB}" add "example.md" --title "Example Title"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --info

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ "${output}" =~ 1               ]]
  [[ "${output}" =~ example.md      ]]
  [[ "${output}" =~ Example\ Title  ]]
  [[ ! "${output}" =~ home          ]]
}

@test "\`show <id> --info\` exits with status 0 and prints scoped note info." {
  {
    run "${_NB}" init
    run "${_NB}" notebooks add one
    run "${_NB}" one:add "example.md" --title "Example Title"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show one:1 --info

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0                ]]
  [[ "${output}" =~ one:1           ]]
  [[ "${output}" =~ one:example.md  ]]
  [[ "${output}" =~ Example\ Title  ]]
}

# `show <id> --type` ##########################################################

@test "\`show <id> --type\` with note exits with status 0 and prints note type." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0      ]]
  [[ "${output}" == "md"  ]]
}

@test "\`show <id> --type\` with bookmark exits with status 0 and prints note type." {
  {
    run "${_NB}" init
    run "${_NB}" bookmark "${_BOOKMARK_URL}"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0      ]]
  [[ "${output}" == "bookmark.md"  ]]
}

@test "\`show <id> --type <extension>\` exits with status 0 when note matches." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type md

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output}"   ]]
}

@test "\`show <id> --type <extension>\` exits with status 0 when bookmark matches." {
  {
    run "${_NB}" init
    run "${_NB}" bookmark "${_BOOKMARK_URL}"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type bookmark.md

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output}"   ]]
}

@test "\`show <id> --type <extension>\` exits with status 0 when bookmark matches one level." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type md

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output}"   ]]
}

@test "\`show <id> --type <type>\` exits with status 0 when note matches." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type text

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output}"   ]]
}

@test "\`show <id> --type <type>\` exits with status 0 when bookmark matches." {
  {
    run "${_NB}" init
    run "${_NB}" bookmark "${_BOOKMARK_URL}"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type bookmark

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0  ]]
  [[ -z "${output}"   ]]
}

@test "\`show <id> --type <type>\` exits with status 1 when no type match." {
  {
    run "${_NB}" init
    run "${_NB}" add

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" show 1 --type not-valid

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 1  ]]
  [[ -z "${output}"   ]]
}

# `show <notebook>` ###########################################################

@test "\`show <notebook>\` exits with status 0 and runs ls in the notebook." {
  {
    run "${_NB}" init
    run "${_NB}" add "home-one.md"
    run "${_NB}" add "home-two.md"
    run "${_NB}" notebooks add example
    run "${_NB}" example:add "example-one.md"
    run "${_NB}" example:add "example-two.md"
  }

  run "${_NB}" show example

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${status}" -eq 0            ]]
  [[ "${lines[0]}" =~ example     ]]
  [[ "${lines[0]}" =~ home        ]]
  [[ "${lines[1]}" =~ ----        ]]
  [[ "${lines[2]}" =~ example-two ]]
  [[ "${lines[3]}" =~ example-one ]]
}

@test "\`show <notebook>:\` (with colon) exits with status 0 and runs ls in the notebook." {
  {
    run "${_NB}" init
    run "${_NB}" add "home-one.md"
    run "${_NB}" add "home-two.md"
    run "${_NB}" notebooks add example
    run "${_NB}" example:add "example-one.md"
    run "${_NB}" example:add "example-two.md"
  }

  run "${_NB}" show example:

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${status}" -eq 0            ]]
  [[ "${lines[0]}" =~ example     ]]
  [[ "${lines[0]}" =~ home        ]]
  [[ "${lines[1]}" =~ ----        ]]
  [[ "${lines[2]}" =~ example-two ]]
  [[ "${lines[3]}" =~ example-one ]]
}

@test "\`show <notebook> --sort\` exits with status 0 and runs ls in the notebook." {
  {
    run "${_NB}" init
    run "${_NB}" add "home-one.md"
    run "${_NB}" add "home-two.md"
    run "${_NB}" notebooks add example
    run "${_NB}" example:add "example-one.md"
    run "${_NB}" example:add "example-two.md"
  }

  run "${_NB}" show example --sort

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${status}" -eq 0            ]]
  [[ "${lines[0]}" =~ example-one ]]
  [[ "${lines[1]}" =~ example-two ]]
}

# `s <id>` #################################################################

@test "\`s <id> --filename\` exits with status 0 and prints note filename." {
  {
    run "${_NB}" init
    run "${_NB}" add "example.md"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" s 1 --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

# `view <id>` #################################################################

@test "\`view <id> --filename\` exits with status 0 and prints note filename." {
  {
    run "${_NB}" init
    run "${_NB}" add "example.md"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" view 1 --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

# `<id> show` alternative  ####################################################

@test "\`<id> show --filename\` exits with status 0 and prints note filename." {
  {
    run "${_NB}" init
    run "${_NB}" add "example.md"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"
  }

  run "${_NB}" 1 show --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

# `<scoped>`  #################################################################

@test "\`show <scope>:<id> --filename\` exits with status 0 and prints note filename." {
  {
    run "${_NB}" init
    run "${_NB}" notebooks add "one"
    run "${_NB}" one:add "example.md"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"

    [[ -e "${NB_DIR}/one/example.md"  ]]
  }

  run "${_NB}" show one:example.md --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

@test "\`<scope>:<id> show --filename\` exits with status 0 and prints note filename." {
  {
    run "${_NB}" init
    run "${_NB}" notebooks add "one"
    run "${_NB}" one:add "example.md"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"

    [[ -e "${NB_DIR}/one/example.md"  ]]
  }

  run "${_NB}" one:example.md show --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

@test "\`<scoped>:show <id> --filename\` exits with status 0 and prints note filename." {
  {
    run "${_NB}" init
    run "${_NB}" notebooks add "one"
    run "${_NB}" one:add "example.md"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"

    [[ -e "${NB_DIR}/one/example.md"  ]]
  }

  run "${_NB}" one:show example.md --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

@test "\`<id> <scoped>:show --filename\` exits with status 0 and prints note filename." {
  {
    run "${_NB}" init
    run "${_NB}" notebooks add "one"
    run "${_NB}" one:add "example.md"

    _files=($(ls "${_NOTEBOOK_PATH}/")) && _filename="${_files[0]}"

    [[ -e "${NB_DIR}/one/example.md"  ]]
  }

  run "${_NB}" example.md one:show --filename

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ ${status} -eq 0              ]]
  [[ "${output}" == "example.md"  ]]
}

# help ########################################################################

@test "\`help show\` exits with status 0." {
  run "${_NB}" help show

  [[ ${status} -eq 0 ]]
}

@test "\`help show\` prints help information." {
  run "${_NB}" help show

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${lines[0]}" =~ Usage\:     ]]
  [[ "${lines[1]}" =~ '  nb show' ]]
}
