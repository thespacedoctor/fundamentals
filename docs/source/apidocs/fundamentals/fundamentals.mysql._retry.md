---
orphan: true
---

# {py:mod}`fundamentals.mysql._retry`

```{py:module} fundamentals.mysql._retry
```

```{autodoc2-docstring} fundamentals.mysql._retry
:allowtitles:
```

## Module Contents

### Functions

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`is_transient_error <fundamentals.mysql._retry.is_transient_error>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.is_transient_error
    :summary:
    ```
* - {py:obj}`next_retry_delay <fundamentals.mysql._retry.next_retry_delay>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.next_retry_delay
    :summary:
    ```
* - {py:obj}`run_with_retries <fundamentals.mysql._retry.run_with_retries>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.run_with_retries
    :summary:
    ```
````

### Data

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`DEADLOCK_ERROR_CODE <fundamentals.mysql._retry.DEADLOCK_ERROR_CODE>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.DEADLOCK_ERROR_CODE
    :summary:
    ```
* - {py:obj}`LOCK_WAIT_TIMEOUT_ERROR_CODE <fundamentals.mysql._retry.LOCK_WAIT_TIMEOUT_ERROR_CODE>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.LOCK_WAIT_TIMEOUT_ERROR_CODE
    :summary:
    ```
* - {py:obj}`RETRYABLE_ERRORS <fundamentals.mysql._retry.RETRYABLE_ERRORS>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.RETRYABLE_ERRORS
    :summary:
    ```
* - {py:obj}`RETRY_BASE_DELAY_SECONDS <fundamentals.mysql._retry.RETRY_BASE_DELAY_SECONDS>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.RETRY_BASE_DELAY_SECONDS
    :summary:
    ```
* - {py:obj}`RETRY_DELAYS <fundamentals.mysql._retry.RETRY_DELAYS>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.RETRY_DELAYS
    :summary:
    ```
* - {py:obj}`RETRY_MAX_DELAY_SECONDS <fundamentals.mysql._retry.RETRY_MAX_DELAY_SECONDS>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.RETRY_MAX_DELAY_SECONDS
    :summary:
    ```
* - {py:obj}`RETRY_TOTAL_SECONDS <fundamentals.mysql._retry.RETRY_TOTAL_SECONDS>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.RETRY_TOTAL_SECONDS
    :summary:
    ```
* - {py:obj}`TRANSIENT_ERROR_CODES <fundamentals.mysql._retry.TRANSIENT_ERROR_CODES>`
  - ```{autodoc2-docstring} fundamentals.mysql._retry.TRANSIENT_ERROR_CODES
    :summary:
    ```
````

### API

````{py:data} DEADLOCK_ERROR_CODE
:canonical: fundamentals.mysql._retry.DEADLOCK_ERROR_CODE
:value: >
   1213

```{autodoc2-docstring} fundamentals.mysql._retry.DEADLOCK_ERROR_CODE
```

````

````{py:data} LOCK_WAIT_TIMEOUT_ERROR_CODE
:canonical: fundamentals.mysql._retry.LOCK_WAIT_TIMEOUT_ERROR_CODE
:value: >
   1205

```{autodoc2-docstring} fundamentals.mysql._retry.LOCK_WAIT_TIMEOUT_ERROR_CODE
```

````

````{py:data} RETRYABLE_ERRORS
:canonical: fundamentals.mysql._retry.RETRYABLE_ERRORS
:value: >
   ()

```{autodoc2-docstring} fundamentals.mysql._retry.RETRYABLE_ERRORS
```

````

````{py:data} RETRY_BASE_DELAY_SECONDS
:canonical: fundamentals.mysql._retry.RETRY_BASE_DELAY_SECONDS
:value: >
   1

```{autodoc2-docstring} fundamentals.mysql._retry.RETRY_BASE_DELAY_SECONDS
```

````

````{py:data} RETRY_DELAYS
:canonical: fundamentals.mysql._retry.RETRY_DELAYS
:value: >
   '_build_retry_delays(...)'

```{autodoc2-docstring} fundamentals.mysql._retry.RETRY_DELAYS
```

````

````{py:data} RETRY_MAX_DELAY_SECONDS
:canonical: fundamentals.mysql._retry.RETRY_MAX_DELAY_SECONDS
:value: >
   16

```{autodoc2-docstring} fundamentals.mysql._retry.RETRY_MAX_DELAY_SECONDS
```

````

````{py:data} RETRY_TOTAL_SECONDS
:canonical: fundamentals.mysql._retry.RETRY_TOTAL_SECONDS
:value: >
   60

```{autodoc2-docstring} fundamentals.mysql._retry.RETRY_TOTAL_SECONDS
```

````

````{py:data} TRANSIENT_ERROR_CODES
:canonical: fundamentals.mysql._retry.TRANSIENT_ERROR_CODES
:value: >
   'frozenset(...)'

```{autodoc2-docstring} fundamentals.mysql._retry.TRANSIENT_ERROR_CODES
```

````

````{py:function} is_transient_error(error)
:canonical: fundamentals.mysql._retry.is_transient_error

```{autodoc2-docstring} fundamentals.mysql._retry.is_transient_error
```
````

````{py:function} next_retry_delay(error, delays)
:canonical: fundamentals.mysql._retry.next_retry_delay

```{autodoc2-docstring} fundamentals.mysql._retry.next_retry_delay
```
````

````{py:function} run_with_retries(log, operation)
:canonical: fundamentals.mysql._retry.run_with_retries

```{autodoc2-docstring} fundamentals.mysql._retry.run_with_retries
```
````
