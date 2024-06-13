# Treatment of localizables

Our scheme for the localizables is the following one:

- For each type of widget (e.g. Button, Label) and each custom object (e.g. Event), we create a yaml file.
- In these yaml files, we use **lowerCamelCase** for each of the keys.
- To properly add them to the app, run the `run_localizables.py` script:

```[bash]
  >>> python scripts/python/run_localizables.py
```

Note that whenever adding a new type, you need to register it in `prefix_registry.json`.

## Further specifications

Generally, when writing in English, we use American English.\
Furthermore, let's agree on the following rules:

- **Buttons**: Their values should always be capitalized.
