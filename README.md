# dotfiles

This is my personal dotfiles manager that I decided to share for others to use. It can help you manage the following:
 - Symbolic links for dotfiles
 - Homebrew apps/casks
 - Cron jobs

It uses a workspace framework that enables varied dotfiles across machines while sharing core setup.
For example, I use three workspaces: base, personal and work. The base workspace is installed on both my personal and
my work machine. Workspaces are designed to operate as separate git repos. The default base workspace is mine so
you will likely want to modify it to your own liking.


## Table of Contents

1. [Setup](#setup)
2. [Workspaces](#workspaces)
   - [Using Local Folders for Workspaces](#using-local-folders-for-workspaces)
   - [Using Cloned GitHub Repos for Workspaces](#using-cloned-github-repos-for-workspaces)
3. [Managing Brew Applications and Casks](#managing-brew-applications-and-casks)
   - [Installing All Managed Applications](#installing-all-managed-applications)
   - [Adding New Applications or Casks to a Workspace](#adding-new-applications-or-casks-to-a-workspace)
   - [Cask Updates](#cask-updates)
4. [Customizing Symlinks](#customizing-symlinks)
5. [Managing Cron Jobs](#managing-cron-jobs)
   - [Job Configuration](#job-configuration)
   - [Deploying Jobs](#deploying-jobs)
   - [Error Logging](#error-logging)

## Setup

1. Clone this repo: `git clone <url>` (fresh install? download zip and extract to home)
2. Install oh-my-zsh: <https://ohmyz.sh/#install>
3. As per [Customizing Symlinks](#customizing-symlinks), setup a symlink-config (oh-my-zsh and zsh required)
4. Deploy config files to your home dir: `./install/symlinks.sh`
5. Reload your terminal with `source ~/.zshrc`, subsequently use the alias `reload`. Expect errors until remaining setup items complete.
6. Install the base apps and casks: `./install/brew.sh`
7. Install python using pyenv: `pyenv -h`
8. Install pipx apps: `./install/pipx.sh`
9. Install a LTS version of node using nvm, this is used to install plugins for neovim: `nvm install --lts`

Optional:
 - Refer to [this guide](https://github.com/drduh/macOS-Security-and-Privacy-Guide?tab=readme-ov-file) for security recommendations.

## Workspaces

Workspaces allow you to maintain different sets of applications and commands for different environments like work and
personal machines. Each workspace is a separate directory under the `workspaces` directory.
Workspaces can be local folders within the `workspaces` directory or you can choose to clone other GitHub repositories
to create separate workspaces.

### Using Local Folders for Workspaces

By default, workspaces are local folders that reside within the `workspaces` directory.
You can use this setup if you want to have separate configurations for different machines or
projects while still sharing the same base configuration. For example:

```bash
dotfiles
└── workspaces
    ├── base
    │     ├── alacritty
    │     ├── brew-apps
    │     ├── brew-casks
    │     ├── nvim
    │     ├── oh-my-zsh
    │     ├── starship
    │     ├── tmux
    │     └── zsh
    ├── personal
    │     ├── brew-apps
    │     ├── brew-casks
    │     └── oh-my-zsh
```

In this example, you have separate `personal` and `work` workspaces that share the same `base` workspace.

### Using Cloned GitHub Repos for Workspaces

If you want to keep your workspace configurations in separate GitHub repositories,
you can clone them directly into the `workspaces` directory.
This allows you to version control your workspace configurations and easily share them across machines. For example:

```bash
dotfiles
└── workspaces
    ├── base
    │     ├── alacritty
    │     ├── brew-apps
    │     ├── brew-casks
    │     ├── nvim
    │     ├── oh-my-zsh
    │     ├── starship
    │     ├── tmux
    │     └── zsh
    ├── personal
    │     ├── brew-apps
    │     ├── brew-casks
    │     └── oh-my-zsh
    └── work
        ├── brew-apps
        ├── brew-casks
        ├── jira
        └── oh-my-zsh
```

In this example, you have separate `personal`, `work`, and `work` workspaces,
with `work` being cloned from another GitHub repository.

## Managing Brew Applications and Casks

A custom command `brewi` has been added to streamline the process of installing and managing Brew applications
and casks across different workspaces.

### Installing All Managed Applications

Refer to 
```shell
install/brew.sh -h
```

### Adding New Applications or Casks to a Workspace

To install a new package and add it to a specific workspace:

```shell
brewi <workspace-name> <app-name>
```

To install a new cask and add it to a specific workspace:

```shell
brewi <workspace-name> -c <cask-name>
```

The `brewi` command installs the new package or cask and also adds it to your workspace-specific `brew-apps` or
`brew-casks` file in the dotfiles repository. This command prevents duplicate entries.
If you try to install an already listed application or cask, it won't add it again to the list.

### Cask Updates

Apps installed with Homebrew Cask may not update during `brew upgrade`.
Apps with self-updating features (indicated by `auto_updates true` in the cask source) or
those marked `version :latest` are skipped to avoid conflicts and downgrades.

To force an upgrade for a specific cask, use:

```shell
brew upgrade <cask>
```

To upgrade all apps, including those with `auto_updates true` or `version :latest`, use the `--greedy` flag:

```shell
brew upgrade --greedy
```

## Customizing Symlinks

The `install/symlinks.sh` script allows you to create symlinks for specific files from each workspace directory to your home directory.
To configure which files to symlink, you can use the `symlink-config` file at the top level of the dotfiles repository.

The `symlink-config` file follows a simple format where each line specifies a workspace and
a directory within that workspace that contains the files you want to symlink. For example:

```
base:alacritty
base:nvim
base:oh-my-zsh
personal:oh-my-zsh
work:jira
work:oh-my-zsh
```

In this example, `alacritty`, `nvim`, and `oh-my-zsh` directories from the `base` workspace will be symlinked,
along with the `oh-my-zsh` directory from the `personal` workspace and
the `jira` and `oh-my-zsh` directories from the `work` workspace.

By using the `symlink-config` file, you can easily control which files get symlinked for each workspace
providing a customizable setup for different environments. When running the `install/symlinks.sh` script,
it will create symlinks for the files specified in the `symlink-config` file in the appropriate locations in your home directory.

## Managing Cron Jobs

The dotfiles project includes a custom script install/jobs.py for managing cron jobs and scheduled scripts.
This tool allows you to define jobs in the jobs.yaml file within each workspace.

### Job Configuration

To create and manage cron jobs, follow these steps:

1. Create a jobs directory within each workspace.
2. Inside the jobs directory, create a jobs.yaml file to define the jobs and their configurations.

The jobs.yaml file should follow the following format:
```yaml
jobs:
  - name: job_name
    source: path_to_dockerfile_directory
    cron: "* * * * *"
    working-dir: path_to_working_directory
```

name: A unique name for the job.
source: The path to the directory containing the Dockerfile for the job.
cron: The cron schedule for the job. You can define the schedule using standard cron syntax (e.g., "* * * * *", "0 0 * * *").
cmd: The path to a directory to be mounted to the container and used as a working directory for persistence.
Access using /data inside the job. (Optional)

#### Environment Variables

If you want to set environment variables in the docker container you can use a .env file in a provided working directory.
This will be utilised by the docker run command via the --env-file flag.

### Deploying Jobs

To deploy jobs from a specific workspace, use the following command:

```bash
python3 install/jobs.py -w <workspace-name>
```

To deploy a specific job from a workspace, use:

```bash
python3 install/jobs.py -j <workspace-name> <job-name>
```
To deploy all jobs from all workspaces, simply run:

```bash
python3 install/jobs.py
```

The install/jobs.py script will build the Docker container using the specified Dockerfile,
create the cron job using the provided schedule, and manage the system crontab for the specified jobs.
