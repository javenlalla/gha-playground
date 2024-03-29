# GitHub Actions Playground

Playground for testing Github Actions workflows.

## Resources

- Quickstart: <https://docs.github.com/en/actions/quickstart>
- Docker Tags and Labels: <https://docs.docker.com/build/ci/github-actions/manage-tags-labels/>
- Auto-update Docker Description: <https://docs.github.com/en/actions/publishing-packages/publishing-docker-images>
- Matrix Documentation: <https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs>
- Build Multiple Images: <https://github.com/docker/build-push-action/issues/561>
- Explicit Tag Formatting: <https://stackoverflow.com/a/70869609>

## Building Local Test Image

```bash
time docker build -t local:gha -f Dockerfile.test .
```
