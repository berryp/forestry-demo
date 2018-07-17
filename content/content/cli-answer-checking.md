---
title: CLI answer checking
---

To check answers in CLI missions, you can use `check val` or `check code run`.

## Example 1: check val

```bash
## Answer

echo "Push the button"

## Check val (this needs to hashes to work)

"butt"
```

*Checks either the CLI input or output for `butt`*

## Example 2: check val

```bash
## Answer

ls -l

## Check val (this needs to hashes to work)

"ls -l'
```

*Checks either the CLI input or output for `ls -;`*

## Example 3: check code run

```bash
## Answer

touch testfile.txt

## Check code run

if [ -e testfile.txt ]; then
    echo "True"
else
   echo "False"
fi
```

*Checks whether `testfile.txt` exists*

## Resources for bash scripting and tests

- http://tldp.org/LDP/abs/html/tests.html