# {py:mod}`fundamentals.nose2_plugins.cprof`

```{py:module} fundamentals.nose2_plugins.cprof
```

```{autodoc2-docstring} fundamentals.nose2_plugins.cprof
:allowtitles:
```

## Module Contents

### Classes

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`Profiler <fundamentals.nose2_plugins.cprof.Profiler>`
  - ```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.Profiler
    :summary:
    ```
````

### Data

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`__all__ <fundamentals.nose2_plugins.cprof.__all__>`
  - ```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.__all__
    :summary:
    ```
* - {py:obj}`log <fundamentals.nose2_plugins.cprof.log>`
  - ```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.log
    :summary:
    ```
````

### API

`````{py:class} Profiler()
:canonical: fundamentals.nose2_plugins.cprof.Profiler

Bases: {py:obj}`nose2.events.Plugin`

```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.Profiler
```

```{rubric} Initialization
```

```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.Profiler.__init__
```

````{py:method} addArgument(callback, short_opt, long_opt, help_text=None)
:canonical: fundamentals.nose2_plugins.cprof.Profiler.addArgument

````

````{py:method} addFlag(callback, short_opt, long_opt, help_text=None)
:canonical: fundamentals.nose2_plugins.cprof.Profiler.addFlag

````

````{py:method} addMethods(*methods)
:canonical: fundamentals.nose2_plugins.cprof.Profiler.addMethods

````

````{py:method} addOption(callback, short_opt, long_opt, help_text=None, nargs=0)
:canonical: fundamentals.nose2_plugins.cprof.Profiler.addOption

````

````{py:attribute} alwaysOn
:canonical: fundamentals.nose2_plugins.cprof.Profiler.alwaysOn
:type: bool
:value: >
   False

````

````{py:method} beforeSummaryReport(event)
:canonical: fundamentals.nose2_plugins.cprof.Profiler.beforeSummaryReport

```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.Profiler.beforeSummaryReport
```

````

````{py:attribute} commandLineSwitch
:canonical: fundamentals.nose2_plugins.cprof.Profiler.commandLineSwitch
:value: >
   ('P', 'profile', 'Run test under cprofile')

```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.Profiler.commandLineSwitch
```

````

````{py:attribute} config
:canonical: fundamentals.nose2_plugins.cprof.Profiler.config
:type: nose2.events.Plugin.config
:value: >
   None

````

````{py:attribute} configSection
:canonical: fundamentals.nose2_plugins.cprof.Profiler.configSection
:value: >
   'profiler'

```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.Profiler.configSection
```

````

````{py:method} register()
:canonical: fundamentals.nose2_plugins.cprof.Profiler.register

````

````{py:attribute} registered
:canonical: fundamentals.nose2_plugins.cprof.Profiler.registered
:type: bool
:value: >
   False

````

````{py:attribute} session
:canonical: fundamentals.nose2_plugins.cprof.Profiler.session
:type: nose2.session.Session
:value: >
   None

````

````{py:method} startTestRun(event)
:canonical: fundamentals.nose2_plugins.cprof.Profiler.startTestRun

```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.Profiler.startTestRun
```

````

`````

````{py:data} __all__
:canonical: fundamentals.nose2_plugins.cprof.__all__
:value: >
   ('Profiler',)

```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.__all__
```

````

````{py:data} log
:canonical: fundamentals.nose2_plugins.cprof.log
:value: >
   'getLogger(...)'

```{autodoc2-docstring} fundamentals.nose2_plugins.cprof.log
```

````
