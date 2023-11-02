# resume-file
cat the lines of a file that have not been seen.

```
    cat some_file
    1
    2
    3
    resume-file some_file
    1
    2
    3
    echo 4 >> some_file
    echo 5 >> some_file
    resume-file some_file
    4
    5
    resume-file -c some_file
    1
    2
    3
    4
    5
```
