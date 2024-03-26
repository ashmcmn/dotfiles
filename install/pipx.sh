if ! command -v pipx &>/dev/null; then
  echo "Pipx is not installed."
else
  pipx install poetry
  pipx install cookiecutter
fi