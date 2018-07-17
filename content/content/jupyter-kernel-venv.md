---
title: Jupyter kernel venv
---

## Creating a Jupyter Kernel with a virtualenv for authoring

This will ensure that the content you author runs against the packages in our live environment. This is important, especially as new versions you run locally may have new methods, or conversely an old package you use locally may have a method that is now deprecated.

- Create a new virtualenv using `virtualenv dscontent`
- Activate that virtualenv: `source dscontent/bin/activate`
- Install the runner container packages from the dsserver repo: `pip install -r /path_to_dsserver_repo/containers/runners/v2-base/requirements/python3/requirements.txt`
- Create a kernel for jupyter using the active virtualenv: `python -m ipykernel install --user --name dscontent --display-name dscontent`