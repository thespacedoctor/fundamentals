# {py:mod}`fundamentals.ssh_tunnel`

```{py:module} fundamentals.ssh_tunnel
```

```{autodoc2-docstring} fundamentals.ssh_tunnel
:allowtitles:
```

## Module Contents

### Functions

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`is_port_open <fundamentals.ssh_tunnel.is_port_open>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.is_port_open
    :summary:
    ```
* - {py:obj}`setup_ssh_tunnel <fundamentals.ssh_tunnel.setup_ssh_tunnel>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.setup_ssh_tunnel
    :summary:
    ```
````

### Data

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`MAX_PORT <fundamentals.ssh_tunnel.MAX_PORT>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.MAX_PORT
    :summary:
    ```
* - {py:obj}`REMOTE_DATABASE_PORT <fundamentals.ssh_tunnel.REMOTE_DATABASE_PORT>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.REMOTE_DATABASE_PORT
    :summary:
    ```
* - {py:obj}`SAFE_ADDRESS <fundamentals.ssh_tunnel.SAFE_ADDRESS>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.SAFE_ADDRESS
    :summary:
    ```
* - {py:obj}`SAFE_HOST <fundamentals.ssh_tunnel.SAFE_HOST>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.SAFE_HOST
    :summary:
    ```
* - {py:obj}`SAFE_USER <fundamentals.ssh_tunnel.SAFE_USER>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.SAFE_USER
    :summary:
    ```
* - {py:obj}`TUNNEL_CHECK_ATTEMPTS <fundamentals.ssh_tunnel.TUNNEL_CHECK_ATTEMPTS>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.TUNNEL_CHECK_ATTEMPTS
    :summary:
    ```
* - {py:obj}`TUNNEL_CHECK_DELAY <fundamentals.ssh_tunnel.TUNNEL_CHECK_DELAY>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.TUNNEL_CHECK_DELAY
    :summary:
    ```
* - {py:obj}`TUNNEL_CONNECT_TIMEOUT <fundamentals.ssh_tunnel.TUNNEL_CONNECT_TIMEOUT>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.TUNNEL_CONNECT_TIMEOUT
    :summary:
    ```
* - {py:obj}`TUNNEL_REQUIRED_KEYS <fundamentals.ssh_tunnel.TUNNEL_REQUIRED_KEYS>`
  - ```{autodoc2-docstring} fundamentals.ssh_tunnel.TUNNEL_REQUIRED_KEYS
    :summary:
    ```
````

### API

````{py:data} MAX_PORT
:canonical: fundamentals.ssh_tunnel.MAX_PORT
:value: >
   65535

```{autodoc2-docstring} fundamentals.ssh_tunnel.MAX_PORT
```

````

````{py:data} REMOTE_DATABASE_PORT
:canonical: fundamentals.ssh_tunnel.REMOTE_DATABASE_PORT
:value: >
   3306

```{autodoc2-docstring} fundamentals.ssh_tunnel.REMOTE_DATABASE_PORT
```

````

````{py:data} SAFE_ADDRESS
:canonical: fundamentals.ssh_tunnel.SAFE_ADDRESS
:value: >
   'compile(...)'

```{autodoc2-docstring} fundamentals.ssh_tunnel.SAFE_ADDRESS
```

````

````{py:data} SAFE_HOST
:canonical: fundamentals.ssh_tunnel.SAFE_HOST
:value: >
   'compile(...)'

```{autodoc2-docstring} fundamentals.ssh_tunnel.SAFE_HOST
```

````

````{py:data} SAFE_USER
:canonical: fundamentals.ssh_tunnel.SAFE_USER
:value: >
   'compile(...)'

```{autodoc2-docstring} fundamentals.ssh_tunnel.SAFE_USER
```

````

````{py:data} TUNNEL_CHECK_ATTEMPTS
:canonical: fundamentals.ssh_tunnel.TUNNEL_CHECK_ATTEMPTS
:value: >
   5

```{autodoc2-docstring} fundamentals.ssh_tunnel.TUNNEL_CHECK_ATTEMPTS
```

````

````{py:data} TUNNEL_CHECK_DELAY
:canonical: fundamentals.ssh_tunnel.TUNNEL_CHECK_DELAY
:value: >
   1

```{autodoc2-docstring} fundamentals.ssh_tunnel.TUNNEL_CHECK_DELAY
```

````

````{py:data} TUNNEL_CONNECT_TIMEOUT
:canonical: fundamentals.ssh_tunnel.TUNNEL_CONNECT_TIMEOUT
:value: >
   5

```{autodoc2-docstring} fundamentals.ssh_tunnel.TUNNEL_CONNECT_TIMEOUT
```

````

````{py:data} TUNNEL_REQUIRED_KEYS
:canonical: fundamentals.ssh_tunnel.TUNNEL_REQUIRED_KEYS
:value: >
   ('remote user', 'remote ip', 'remote datbase host', 'port')

```{autodoc2-docstring} fundamentals.ssh_tunnel.TUNNEL_REQUIRED_KEYS
```

````

````{py:function} is_port_open(address, port, log)
:canonical: fundamentals.ssh_tunnel.is_port_open

```{autodoc2-docstring} fundamentals.ssh_tunnel.is_port_open
```
````

````{py:function} setup_ssh_tunnel(tunnelParameters, log, checkHost='127.0.0.1')
:canonical: fundamentals.ssh_tunnel.setup_ssh_tunnel

```{autodoc2-docstring} fundamentals.ssh_tunnel.setup_ssh_tunnel
```
````

`````{py:exception} tunnel_error()
:canonical: fundamentals.ssh_tunnel.tunnel_error

Bases: {py:obj}`Exception`

```{autodoc2-docstring} fundamentals.ssh_tunnel.tunnel_error
```

```{rubric} Initialization
```

```{autodoc2-docstring} fundamentals.ssh_tunnel.tunnel_error.__init__
```

```{py:class} __cause__
:canonical: fundamentals.ssh_tunnel.tunnel_error.__cause__

```

```{py:class} __context__
:canonical: fundamentals.ssh_tunnel.tunnel_error.__context__

```

````{py:method} __delattr__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__delattr__

````

````{py:method} __dir__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__dir__

````

````{py:method} __eq__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__eq__

````

````{py:method} __format__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__format__

````

````{py:method} __ge__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__ge__

````

````{py:method} __getattribute__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__getattribute__

````

````{py:method} __getstate__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__getstate__

````

````{py:method} __gt__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__gt__

````

````{py:method} __hash__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__hash__

````

````{py:method} __le__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__le__

````

````{py:method} __lt__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__lt__

````

````{py:method} __ne__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__ne__

````

````{py:method} __new__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__new__

````

````{py:method} __reduce__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__reduce__

````

````{py:method} __reduce_ex__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__reduce_ex__

````

````{py:method} __repr__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__repr__

````

````{py:method} __setattr__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__setattr__

````

````{py:method} __setstate__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__setstate__

````

````{py:method} __sizeof__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__sizeof__

````

````{py:method} __str__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__str__

````

````{py:method} __subclasshook__()
:canonical: fundamentals.ssh_tunnel.tunnel_error.__subclasshook__

````

```{py:class} __suppress_context__
:canonical: fundamentals.ssh_tunnel.tunnel_error.__suppress_context__

```

```{py:class} __traceback__
:canonical: fundamentals.ssh_tunnel.tunnel_error.__traceback__

```

````{py:method} add_note()
:canonical: fundamentals.ssh_tunnel.tunnel_error.add_note

````

```{py:class} args
:canonical: fundamentals.ssh_tunnel.tunnel_error.args

```

````{py:method} with_traceback()
:canonical: fundamentals.ssh_tunnel.tunnel_error.with_traceback

````

`````
