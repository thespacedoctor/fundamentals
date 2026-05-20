# {py:mod}`fundamentals.logs`

```{py:module} fundamentals.logs
```

```{autodoc2-docstring} fundamentals.logs
:allowtitles:
```

## Module Contents

### Classes

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`ColorFormatter <fundamentals.logs.ColorFormatter>`
  -
* - {py:obj}`GroupWriteRotatingFileHandler <fundamentals.logs.GroupWriteRotatingFileHandler>`
  - ```{autodoc2-docstring} fundamentals.logs.GroupWriteRotatingFileHandler
    :summary:
    ```
* - {py:obj}`emptyLogger <fundamentals.logs.emptyLogger>`
  - ```{autodoc2-docstring} fundamentals.logs.emptyLogger
    :summary:
    ```
````

### Functions

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`addLoggingLevel <fundamentals.logs.addLoggingLevel>`
  - ```{autodoc2-docstring} fundamentals.logs.addLoggingLevel
    :summary:
    ```
* - {py:obj}`console_logger <fundamentals.logs.console_logger>`
  - ```{autodoc2-docstring} fundamentals.logs.console_logger
    :summary:
    ```
* - {py:obj}`setup_dryx_logging <fundamentals.logs.setup_dryx_logging>`
  - ```{autodoc2-docstring} fundamentals.logs.setup_dryx_logging
    :summary:
    ```
````

### API

`````{py:class} ColorFormatter(fmt=None, datefmt=None, style='%', validate=True, *, defaults=None)
:canonical: fundamentals.logs.ColorFormatter

Bases: {py:obj}`logging.Formatter`

````{py:attribute} converter
:canonical: fundamentals.logs.ColorFormatter.converter
:value: >
   None

````

````{py:attribute} default_msec_format
:canonical: fundamentals.logs.ColorFormatter.default_msec_format
:value: >
   '%s,%03d'

````

````{py:attribute} default_time_format
:canonical: fundamentals.logs.ColorFormatter.default_time_format
:value: >
   '%Y-%m-%d %H:%M:%S'

````

````{py:attribute} format
:canonical: fundamentals.logs.ColorFormatter.format
:value: >
   '%(asctime)s - %(name)s - %(levelname)s - %(message)s (%(filename)s:%(lineno)d)'

```{autodoc2-docstring} fundamentals.logs.ColorFormatter.format
```

````

````{py:method} formatException(ei)
:canonical: fundamentals.logs.ColorFormatter.formatException

````

````{py:method} formatMessage(record)
:canonical: fundamentals.logs.ColorFormatter.formatMessage

````

````{py:method} formatStack(stack_info)
:canonical: fundamentals.logs.ColorFormatter.formatStack

````

````{py:method} formatTime(record, datefmt=None)
:canonical: fundamentals.logs.ColorFormatter.formatTime

````

````{py:method} setFormat(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s (%(filename)s:%(lineno)d)', dateFmt='%H:%M:%S')
:canonical: fundamentals.logs.ColorFormatter.setFormat

```{autodoc2-docstring} fundamentals.logs.ColorFormatter.setFormat
```

````

````{py:method} usesTime()
:canonical: fundamentals.logs.ColorFormatter.usesTime

````

`````

`````{py:class} GroupWriteRotatingFileHandler(filename, mode='a', maxBytes=0, backupCount=0, encoding=None, delay=False, errors=None)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler

Bases: {py:obj}`logging.handlers.RotatingFileHandler`

```{autodoc2-docstring} fundamentals.logs.GroupWriteRotatingFileHandler
```

```{rubric} Initialization
```

```{autodoc2-docstring} fundamentals.logs.GroupWriteRotatingFileHandler.__init__
```

````{py:attribute} __class_getitem__
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.__class_getitem__
:value: >
   'classmethod(...)'

````

````{py:method} __repr__()
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.__repr__

````

````{py:method} acquire()
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.acquire

````

````{py:method} addFilter(filter)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.addFilter

````

````{py:method} close()
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.close

````

````{py:method} createLock()
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.createLock

````

````{py:method} doRollover()
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.doRollover

```{autodoc2-docstring} fundamentals.logs.GroupWriteRotatingFileHandler.doRollover
```

````

````{py:method} emit(record)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.emit

````

````{py:method} filter(record)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.filter

````

````{py:method} flush()
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.flush

````

````{py:method} format(record)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.format

````

````{py:method} get_name()
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.get_name

````

````{py:method} handle(record)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.handle

````

````{py:method} handleError(record)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.handleError

````

````{py:attribute} name
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.name
:value: >
   'property(...)'

````

````{py:attribute} namer
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.namer
:value: >
   None

````

````{py:method} release()
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.release

````

````{py:method} removeFilter(filter)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.removeFilter

````

````{py:method} rotate(source, dest)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.rotate

````

````{py:method} rotation_filename(default_name)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.rotation_filename

````

````{py:attribute} rotator
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.rotator
:value: >
   None

````

````{py:method} setFormatter(fmt)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.setFormatter

````

````{py:method} setLevel(level)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.setLevel

````

````{py:method} setStream(stream)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.setStream

````

````{py:method} set_name(name)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.set_name

````

````{py:method} shouldRollover(record)
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.shouldRollover

````

````{py:attribute} terminator
:canonical: fundamentals.logs.GroupWriteRotatingFileHandler.terminator
:value: >
   '\n'

````

`````

````{py:function} addLoggingLevel(levelName, levelNum, methodName=None)
:canonical: fundamentals.logs.addLoggingLevel

```{autodoc2-docstring} fundamentals.logs.addLoggingLevel
```
````

````{py:function} console_logger(level='WARNING')
:canonical: fundamentals.logs.console_logger

```{autodoc2-docstring} fundamentals.logs.console_logger
```
````

`````{py:class} emptyLogger
:canonical: fundamentals.logs.emptyLogger

Bases: {py:obj}`object`

```{autodoc2-docstring} fundamentals.logs.emptyLogger
```

````{py:method} critical(argu)
:canonical: fundamentals.logs.emptyLogger.critical

```{autodoc2-docstring} fundamentals.logs.emptyLogger.critical
```

````

````{py:method} debug(argu)
:canonical: fundamentals.logs.emptyLogger.debug

```{autodoc2-docstring} fundamentals.logs.emptyLogger.debug
```

````

````{py:method} error(argu)
:canonical: fundamentals.logs.emptyLogger.error

```{autodoc2-docstring} fundamentals.logs.emptyLogger.error
```

````

````{py:method} info(argu)
:canonical: fundamentals.logs.emptyLogger.info

```{autodoc2-docstring} fundamentals.logs.emptyLogger.info
```

````

````{py:method} print(argu)
:canonical: fundamentals.logs.emptyLogger.print

```{autodoc2-docstring} fundamentals.logs.emptyLogger.print
```

````

````{py:method} warning(argu)
:canonical: fundamentals.logs.emptyLogger.warning

```{autodoc2-docstring} fundamentals.logs.emptyLogger.warning
```

````

`````

````{py:function} setup_dryx_logging(yaml_file)
:canonical: fundamentals.logs.setup_dryx_logging

```{autodoc2-docstring} fundamentals.logs.setup_dryx_logging
```
````
