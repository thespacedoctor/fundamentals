# Installation

The easiest way to install fundamentals is to use `pip` (here we show the install inside of a conda environment):

``` bash
conda create -n fundamentals python=3.7 pip
conda activate fundamentals
pip install fundamentals
```

Or you can clone the [github repo](https://github.com/thespacedoctor/fundamentals) and install from a local version of the code:

``` bash
git clone git@github.com:thespacedoctor/fundamentals.git
cd fundamentals
python setup.py install
```

To upgrade to the latest version of fundamentals use the command:

``` bash
pip install fundamentals --upgrade
```


## Development

If you want to tinker with the code, then install in development mode. This means you can modify the code from your cloned repo:

``` bash
git clone git@github.com:thespacedoctor/fundamentals.git
cd fundamentals
python setup.py develop
```

[Pull requests](https://github.com/thespacedoctor/fundamentals/pulls) are welcomed! 

<!-- ### Sublime Snippets

If you use [Sublime Text](https://www.sublimetext.com/) as your code editor, and you're planning to develop your own python code with soxspipe, you might find [my Sublime Snippets](https://github.com/thespacedoctor/fundamentals-Sublime-Snippets) useful. -->


