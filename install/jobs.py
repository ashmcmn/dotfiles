#!/usr/bin/env python3
import argparse
import crontab
import yaml
import docker
import logging
from pathlib import Path

DOTFILES_DIR = Path("~").expanduser() / "dotfiles"
WORKSPACES_DIR = DOTFILES_DIR / "workspaces"

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def deploy_job(workspace, job_name):
    workspace_dir = WORKSPACES_DIR / workspace
    jobs_dir = workspace_dir / "jobs"
    job_dir = jobs_dir / job_name

    client = docker.from_env()
    logger.info(f"Building Docker image for job {job_name}...")
    client.images.build(path=str(job_dir), tag=f"{job_name}")

    jobs_config_file = jobs_dir / "jobs.yaml"
    with open(jobs_config_file) as f:
        jobs_config = yaml.safe_load(f)

    job_config = jobs_config["jobs"][job_name]
    cron_entry = job_config["cron"]
    cmd = f"{job_config['cmd']}"

    cron = crontab.CronTab(user=True)
    for existing_job in cron.find_comment(job_name):
        logger.info(f"Removing existing cron job {existing_job}...")
        cron.remove(existing_job)

    job = cron.new(command=cmd)
    job.setall(cron_entry)
    job.set_comment(job_name)
    logger.info(f"Scheduling job {job_name} with cron entry: {cron_entry}")
    cron.write()


def deploy_workspace_jobs(workspace):
    jobs_dir = WORKSPACES_DIR / workspace / "jobs"
    jobs_config_file = jobs_dir / "jobs.yaml"
    if jobs_dir.exists() and jobs_config_file.exists():
        with open(jobs_config_file) as f:
            jobs_config = yaml.safe_load(f)
        for job_name in jobs_config["jobs"]:
            deploy_job(workspace, job_name)
    else:
        logger.info(f"No jobs found in {workspace}.")


def deploy_all_jobs():
    for workspace_dir in WORKSPACES_DIR.iterdir():
        if workspace_dir.is_dir():
            workspace = workspace_dir.name
            logger.info(f"Deploying jobs in workspace: {workspace}")
            deploy_workspace_jobs(workspace)


def main():
    parser = argparse.ArgumentParser(description="Manage scheduled jobs.")
    parser.add_argument("-w", "--workspace", help="Deploy jobs from a specific workspace")
    parser.add_argument("-j", "--job", help="Deploy a specific job from a workspace")

    args = parser.parse_args()

    if args.job:
        deploy_job(args.workspace, args.job)
    elif args.workspace:
        deploy_workspace_jobs(args.workspace)
    else:
        deploy_all_jobs()


if __name__ == "__main__":
    main()
