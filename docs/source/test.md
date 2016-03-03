

# MultiMarkdown Syntax Guide #

This guide has been lifted directly from Penny Fletcher's [Multimarkdown Github Repo](https://github.com/fletcher/MultiMarkdown "fletcher/MultiMarkdown · GitHub"). I'm using it to make sure all syntax is rendering correctly on these pages.

This is a guide to the markup syntax used in the MultiMarkdown system.

## Metadata ##

MultiMarkdown has support for metadata, meaning that you can include
information about a document that is not necessarily part of the document
contents.

To use metadata, simply add information to the top of a Markdown file:

    Title:  A New MultiMarkdown Document  
    Author: Fletcher T. Penney  
            John Doe  
    Date:   July 25, 2005  

The key is the text before the colon, and the data is the text after the
colon. In the above example, notice that there are two lines of information
for the Author key. If you end a line with "space-space-newline", the newline
will be included when converted to other formats.

There must not be any whitespace above the metadata, and the metadata block
ends with the first whitespace only line. The metadata is stripped from the
document before it is passed on to the syntax parser.

While not required, I recommend including two spaces at the end of each line
of metadata. In this way, if you pass your document through a regular version
of Markdown, the metadata will be properly formatted as plain text with line
breaks, rather than joined into a single run-on paragraph.

I have included information about some of the "standard" metadata keys --- I
welcome feedback and suggestions for additional standard keys that would be
useful. If you add keys that are not listed, they are included in the XHTML
and LaTeX as custom variables that can still be used if you desire.

Remember, XHTML snippets have no means to use metadata. To make use of these
features, one must be using `Format: complete` to create full XHTML documents,
which can then be processed using XSLT to create other document types. As an
example, I use metadata for information that is used to add title, author,
keyword, and copyright metadata to PDF's created by MultiMarkdown.

**Note**: I make multiple mentions to the use of these keys for LaTeX
documents. This is simply because the LaTeX output format currently makes the
most use of the metadata information. Any export format could be modified to
make use of additional metadata keys.

### Address ###

Use this to include the author's mailing address. You can have more than one
line in this field --- use two extra spaces at the end of a line, and a
newline character will be used in LaTeX. Also used as return address for
letterhead and envelope templates.

### Author ###

Self-explanatory. I strip this out to provide an author string to LaTeX
documents.  Also used as the sender for letterhead and envelope templates.


### Affiliation ###

Use this to include an organization that the author is affiliated with, e.g. a
university, company, or organization. You can include address information here
as well, or use the `Address`, `email`, `web`, and `phone` metadata fields.
You can have more than one line in this field --- use two extra spaces at the
end of the line, and a newline character will be used in LaTeX.


### Base Header Level ###

Used by my XSLT script tool to change the default header level. For example,
if using the memoir class, you might want a first level header to be
interpreted as a chapter, rather than as a part. To do this, simply set `Base
Header Level` to `2`.

### Base URL (Deprecated)###

Deprecated - WikiWords and WikiLinks no longer supported.


### Bibliography Title ###

Change the title used for the references section (e.g. "References" or
"Bibliography"). The default value is "Bibliography".


### Bibliography Style ###

The name of the BibTeX style you wish to use.


### BibTeX ###

This should be the name of a `.bib` file (a BibTeX file used to store
references). If you use my xhtml2latex.xslt file, this will convert external
citations into markup for BibTeX (see [Bibliography Support][] for more
information).

You must have `bibtex` installed and working, and the `.bib` file must be in
your working directory.

 
### Copyright ###

This can be used to provide a copyright string.


### CSS ###

Used to specify a CSS stylesheet when creating the complete XHTML output.


### Date ###

Provide a date for the document.


### Email ###

Use this to include the author's email address.

### Format ###

Set to `complete` to indicate that a fully-formed XHTML document should be
produced. Such a document is ready for processing by an XSLT tool, such as the
XSLT files to convert XHTML into LaTeX.

Set to `snippet` to indicate that no `<head>` or other information should be
included. This might be useful for generating (X)HTML output ready for pasting
into a weblog, for example.

**Note**: Some MultiMarkdown tools add this for you (e.g. TextMate using my
bundle, and Scrivener.) Duplicating the `Format` key in these programs should
not cause a problem --- let me know if you have trouble.

### Keywords ###

Provide a list of keywords for the document. I use these to add keywords to
PDF's that are produced as well. Keywords can be separated by commas, or
placed on separate lines.


### Language ###

Currently, the language field is used to specify which version of
[SmartyPants] to use. In the future, it may be used for other purposes as
well.

The languages are written using the English word (e.g. "german" not
"deutsch").

[SmartyPants]: http://daringfireball.net/projects/smartypants/ "SmartyPants Homepage"


### LaTeX XSLT ###

Used to designate an XSLT file to convert an XHTML document to a LaTeX
document. The LaTeX document can then be converted to PDF by `pdflatex`. This
key used to be called `XSLT File`.


### My Chapter Style ###

This is used to designate the `mychapterstyle` in LaTeX memoir documents.


### My Page Style ###

This is used to designate the `pagestyle` in LaTeX memoir documents.

### Phone ###

Use this to include the author's phone number(s). You can have more than one
line in this field --- use two extra spaces at the end of the line, and a
newline character will be used in LaTeX.


### Recipient ###

Used by letterhead and envelope templates.


### Recipient Address ###

Used by letterhead and envelope templates.


### Revision ###

You can use a string to declare the current version of the document. Displayed
on the copyright page when using my memoir XSLT transform.


### RTF XSLT ###

This key is used to provide an XSLT file that can alter the XHTML output prior
to conversion to RTF. Useful for further customizing the output of
MultiMarkdown specifically for the RTF format. I have no plans to create any
such files myself, but others may find it useful.

*I strongly encourage you to use another route to convert XHTML to RTF.  
I've had the best results with [Google Docs](http://docs.google.com/).  For 
non-Mac users, that's definitely the way to go.*

### Subtitle ###

Used to provide a subtitle. It ends up in the meta tags, but can be extracted
by XSLT for other uses.


### Title ###

Used to provide the official title of a document. This is set as the `<title>`
string within the `<head>` section of an HTML document, and is also used by
other export formats.


### Use WikiLinks (Deprecated)###

Set to `true` or `1` to enable the use of `WikiWords` and `[[Free Links]]`.
Requires that you also set `Base URL`. See [WikiLinks (Deprecated)][] for more information.


### Web ###

Use this to include the author's web URL.


### XHTML Header ###

This is used to include raw XHTML information in the header of a document. You
can use this field to add information that will be included in the header of
the generated XHTML file. This can be CSS formatting data, or javascript code,
or just about anything. I am not responsible for getting that code to work.
MultiMarkdown just includes it as is.

Anything included in this field is inserted, unaltered, in the `<head>`
section of the XHTML output. If you do add anything here, the XSLT stylesheet
may have to updated to ignore what you added if you want to convert to LaTeX.
Let me know what you add, and I can consider updating the XSLT stylesheet to
ignore it. Currently it ignores `<style>` sections.


### XHTML XSLT ###

This is the name of the XSLT file to use to post-process the XHTML file. This
can be used to further customize the XHTML output generated by MultiMarkdown.
For example, the `xhtml-toc.xslt` file can add a Table of Contents to the
start of XHTML page.



### XMP ###

This is used to provide a file to be included using
[xmpincl](http://www.ctan.org/tex-archive/macros/latex/contrib/xmpincl/).
Basically, this adds the ability to provide Creative Commons Licensing
information in a PDF's [metadata](http://wiki.creativecommons.org/XMP).
It can also be used for other purposes (beyond the scope of this document.)


### XSLT File (deprecated)###

This metadata key has been deprecated in favor of `XHTML XSLT`, `RTF XSLT`,
and `LaTeX XSLT`.

## Automatic Cross-References ##

An oft-requested feature was the ability to have Markdown automatically handle
within-document links as easily as it handled external links. To this aim, I
added the ability to interpret `[Some Text][]` as a cross-link, if a header
named "Some Text" exists.

As an example, `[Metadata][]` will take you to the
[section describing metadata][Metadata].

Alternatively, you can include an optional label of your choosing to help
disambiguate cases where multiple headers have the same title:

    ### Overview [MultiMarkdownOverview] ##

This allows you to use `[MultiMarkdownOverview]` to refer to this section
specifically, and not another section named `Overview`. This works with atx-
or settext-style headers.

If you have already defined an anchor using the same id that is used by a
header, then the defined anchor takes precedence.

In addition to headers within the document, you can provide labels for images
and tables which can then be used for cross-references as well.

## Image Support ##

![This is a **bolded** caption][Weird Bird]

[Weird Bird]: http://25.media.tumblr.com/tumblr_m9we8taUh71rx93fyo1_1280.jpg "Weird Bird" width="400px"

Obviously, images are handled just fine by Markdown (with the exception of
attributes as noted above.) However, without some more information, images are
not easily translated into other document formats (e.g. PDF).

To handle this, my XSLT files will make use of `<img>` dimensions (e.g.
`height` and `width`). If present, the image will be scaled. If only one
dimension is specified, the image will be scaled proportionately. If neither
`height` nor `width` is specified, then the image will be scaled such that
its width is the same as a column of text. This is to prevent high resolution
images from overflowing the page. Unfortunately, it has the side effect of
"zooming" in on smaller images. So, if you have images that are being scaled
in a way that you do not desire, simply specify at least one dimension.

*Note: XHTML only allows for units of `px` and `%` on `<img>` tags. LaTeX
allows for several others. So, my XSLT file allows for other units to be used,
even if they screw up the XHTML version. You have to choose appropriate units
for your purpose. Unfortunately, the only way around this is to make sure that
all of your images contain actual dimension information, and then remove the
`\resizebox` part from the XSLT.*

## Anchor and Image Attributes ##

Adding attributes to links and images has been requested for a long time on
the Markdown discussion list. I was fairly opposed to this, as most of the
proposals really disrupted the readability of the syntax. I consider myself a
"Markdown purist", meaning that I took John's introduction to heart:

> The overriding design goal for Markdown's formatting syntax is to make
> it as readable as possible. The idea is that a Markdown-formatted
> document should be publishable as-is, as plain text, without looking
> like it's been marked up with tags or formatting instructions. While
> Markdown's syntax has been influenced by several existing text-to-HTML
> filters, the single biggest source of inspiration for Markdown's
> syntax is the format of plain text email.

Because there was not a syntax proposal that I felt fit this goal, I was generally opposed to the idea.

Then, Choan C. Gálvez [proposed][galvez] a brilliantly simple syntax that
stayed out of the way. By simply appending the attributes to the link
reference information, which is already removed from the text itself, it
doesn't disturb the readability.

[galvez]: http://six.pairlist.net/pipermail/markdown-discuss/2005-October/001578.html

For example:

    This is a formatted ![image][] and a [link][] with attributes.
    
    [image]: http://path.to/image "Image title" width=40px height=400px
    [link]:  http://path.to/link.html "Some Link" class=external
             style="border: solid black 1px;"

This will generate width and height attributes for the image, and a border
around the link. And while it can be argued that it does look "like it's been
marked up with tags [and] formatting instructions", even I can't argue too
strongly against it. The link and the title in quotes already look like some
form of markup, and the additional tags are hardly that intrusive, and
they offer a great deal of functionality. They might even be useful in further
functions (citations?).

The attributes must continue after the other link/image data, and may contain
newlines, but must start at the beginning of the line. The format is
`attribute=value` or `attribute="multi word value"`. Currently, MultiMarkdown
does not attempt to interpret or make any use of any of these attributes.
Also, you can't have a multiword attribute span a newline.


## WikiLinks (Deprecated)##



**Note:** The WikiLinks feature was more trouble than it was worth, and has
been removed. One can still use the wiki software to manage these links. For
example, my [MultiMarkdown Extension] for [Oddmuse](http://www.oddmuse.org/)
supports Oddmuse styled WikiLinks.

[MultiMarkdown Extension]: http://www.oddmuse.org/cgi-bin/oddmuse/Markdown_Extension


## Footnotes ##


I have added support for footnotes to MultiMarkdown, using the syntax proposed
by John Gruber. Note that there is no official support for footnotes yet, so
the output format may change, but the input format sounds fairly stable.

To create a footnote, enter something like the following:

    Here is some text containing a footnote.[^somesamplefootnote]
    
    [^somesamplefootnote]: Here is the text of the footnote itself.
    
    [somelink]:http://somelink.com


The footnote itself must be at the start of a line, just like links by
reference. If you want a footnote to have multiple paragraphs, lists, etc.,
then the subsequent paragraphs need an extra tab preceding them. You may have
to experiment to get this just right, and please let me know of any issues you
find.

This is what the final result looks like:

> Here is some text containing a footnote.[^somesamplefootnote]

[^somesamplefootnote]: Here is the text of the footnote itself.

## Tables ##


I have implemented a syntax for tables similar to that used by Michael
Fortin's [PHP Markdown Extra][].

[PHP Markdown Extra]: http://michelf.com/projects/php-markdown/extra

Basically, it allows you to turn:

    |             |          Grouping           ||
    First Header  | Second Header | Third Header |
     ------------ | :-----------: | -----------: |
    Content       |          *Long Cell*        ||
    Content       |   **Cell**    |         Cell |
    
    New section   |     More      |         Data |
    And more      |            And more          ||
    [Prototype table]

into a [table][Prototype Table].

|            |          Grouping           ||
First Header | Second Header | Third Header |
| ---------- | :-----------: | -----------: |
Content      |         *Long Cell*         ||
Content      |    **Cell**   |         Cell |
New section  |      More     |         Data |
And more     |          And more           ||


| Test  | Second |
| :------------ | :----------- |
| xxxxx     | xxxxx  |
| xxxxx     | xxxxx  |




The requirements are:

* There must be at least one `|` per line
* The second line must contain only `|`,`-`,`:`,`.`, or spaces
* Cell content must be on one line only
* No blank lines
* Columns are separated by `|`
* The first line of the table, and the alignment/divider line, must start at 
    the beginning of the line

Other notes:

* It is optional whether you have `|`'s at the beginning and end of lines.

* To set alignment, you can use a colon to designate left or right alignment,
  or a colon at each end to designate center alignment, as above. If no colon
  is present, the default alignment of your system is selected (left in most
  cases). If you use a period character (`.`), then `char` alignment is used -
  in the future this will allow columns of decimal formatted numbers to be
  aligned on the decimal character. Browsers do not currently support this
  feature, so it is somewhat useless at the moment. It could be used in an
  XSLT stylesheet for other output formats (e.g. LaTeX).

* To indicate that a cell should span multiple columns, there simply add
  additional pipes (`|`) at the end of the cell, as shown in the example. If
  the cell in question is at the end of the row, then of course that means
  that pipes are not optional at the end of that row....

* You can use normal Markdown markup within the table cells.

* Captions are optional, but if present must be at the beginning of the line
  immediately preceding or following the table, start with `[`, and end with
  `]`. If you have a caption before and after the table, only the first match
  will be used.

* If you have a caption, you can also have a label, allowing you to create
  anchors pointing to the table. If there is no label, then the caption acts
  as the label

* Cells can be empty.

* You can create multiple `<tbody>` tags within a table by having a **single**
  empty line between rows of the table. This allows your CSS to place
  horizontal borders to emphasize different sections of the table.

* If there is no header for the first column, then cells in that column will
  be treated as headers, and formatted as such.


## Bibliography Support ##

I have included support for *basic* bibliography features in this version of
MultiMarkdown. Please give me feedback on ways to improve this but keep the
following in mind:

1. Bibliography support in MultiMarkdown is rudimentary. The goal is to offer
a basic standalone feature, that can be changed using the tool of your choice
to a more robust format (e.g. BibTeX, CiteProc). My XSLT files demonstrate how
to make this format compatible with BibTeX, but I am not planning on
personally providing compatibility with other tools. Feel free to post your
ideas and tools to the wiki.

2. Those needing more detailed function sets for their bibliographies may need
customized tools to provide those services. This is a basic tool that should
work for most people. Reference librarians will probably not be satisfied
however.


To use citations in MultiMarkdown, you use a syntax much like that for
anchors:

    This is a statement that should be attributed to
    its source[p. 23][#Doe:2006].
    
    And following is the description of the reference to be
    used in the bibliography.
    
    [#Doe:2006]: John Doe. *Some Big Fancy Book*.  Vanity Press, 2006.

The XHTML that is generated is as follows:

    <p>This is a statement that should be attributed to its source
    <span class="markdowncitation"> (<a href="#Doe:2006">1</a>, <span 
    class="locator">p. 23</span>)</span>.</p>
    
    <p>And following is the description of the reference to be used
    in the bibliography.</p>
    
    <div class="bibliography">
    <hr />
    <p>Bibliography</p>
    
    <div id="Doe:2006"><p>[1] John Doe. <em>Some Big Fancy Book</em>.
    Vanity Press, 2006.</p></div>
    
    </div>

You are not required to use a locator (e.g. p. 23), and there are
no special rules on what can be used as a locator if you choose
to use one. If you prefer to omit the locator, just use an empty
set of square brackets before the citation:

    This is a statement that should be attributed to its 
    source[#Doe:2006][].

The empty square brackets have to be placed AFTER the reference, not before.

There are no rules on the citation key format that you use (e.g. `Doe:2006`),
but it must be preceded by a `#`, just like footnotes use `^`.

As for the reference description, you can use Markup code within this section,
and I recommend leaving a blank line afterwards to prevent concatenation of
several references. Note that there is no way to reformat these references in
different bibliography styles; for this you need a program designed for that
purpose (e.g. BibTeX).

If you want to include a source in your bibliography that was not cited, you
may use the following:

    [Not cited][#citekey]

The `Not cited` bit is not case sensitive.


### MultiMarkdown References ###

If you define your references (as in the example above), MultiMarkdown will
automatically append a basic bibliography to the end of your document. The
citations will of the form:

    <span class="markdowncitation"> (<a href="#citekey">#
    </a>, <span class="locator">p. 23</span>)</span>

If you don't define a locator, you will get:

    <span class="markdowncitation"> (<a href="#citekey">#
    </a>)</span>

When you click on the `#` (which is replaced with the specific reference
number), it takes you to the appropriate point in the Bibliography. Unlike
footnotes, there is no reverse link.


### External References ###

If you do not define references, then MultiMarkdown will substitute different
markup that can be used by XSLT to transform it into markup for an external
tool, e.g. BibTeX.

    <span class="externalcitation"> (<a id="citekey">citekey</a>, <span 
    class="locator">p. 23</span>)</span>

If you don't define a locator, you will get:

    <span class="externalcitation"> (<a id="citekey">citekey</a>)</span>


Obviously, the citekey that you use in MultiMarkdown must match that used by
your external tool.

[MultiMarkdownDragAndDrop]: http://fletcherpenney.net/Applications_That_Support_MultiMarkdown#multimarkdowndraganddrop "MultiMarkdown Drag and Drop"

### Multiple Citations ###

When you need to combine multiple citations together, simply add them
serially:

    [p. 3][#Doe:1996][p. 10][#Smith:2005]

giving the output:

    (1, p. 3) (2, p. 10)

Notice that empty square brackets have to be placed AFTER the reference if you don't want to use a locator:

    [#Doe:1996][][#Smith:2005][]

I recognize that this is not really a standardized format, but again I remind
you that the bibliography support in MultiMarkdown is minimal. If you want
more control, or adherence to proper style rules, you need a more powerful
bibliography tool.

I have written a perl script that will join these serial citations into one,
`cleancites.pl`. It is run by default by the default MultiMarkdown usage
scripts.

### BibTeX Support ###

If you are a user of BibTeX, you may use it to control your references. Simply
set the `Bibtex` and `Bibliographystyle` metadata as described in the section
on [Metadata][], and use my xhtml2latex XSLT files as examples.

If you use this, you are not required to define your references within your
MultiMarkdown document.

### Advanced Citations with natbib ###

Advanced LaTeX users are probably familiar with the
[natbib](http://www.ctan.org/tex-archive/help/Catalogue/entries/natbib.html)
package, which adds additional features for bibliographic citations. It offers
two new citation commands, `\citet` and `\citep`.

To use the advanced natbib features:

1. You must have the natbib package installed for LaTeX
2. You must use an appropriate XSLT file that enables the natbib package (`memoir-natbib.xslt` is an example - you can make your own)


By default, citations occur using the `\citep` command.

To use a `\citet` citation, follow the example below:

    In their seminal paper, [Smith and Jones; p 42][#Smith1990] argue
    convincingly that....
    
    [#Smith1990]: Smith, R, and Jones, K. *Some Fancy Article* etc...

The text before the semi-colon indicates that we want a textual citation. In
the XHTML version, the text you enter becomes the text in the sentence. When
converted to LaTeX, your text is actually removed and the natbib package
handles it for you. The text after the semi-colon is the usual locator text
(if you don't want a locator, just leave it blank after the semi-colon).

If you don't include a semi-colon, then the `\citep` command is used in the
usual fashion.

## Math Support ##

MultiMarkdown 2.0 supported [ASCIIMathML] embedded with MultiMarkdown
documents. This syntax was then converted to MathML for XHTML output, and then
further processed into LaTeX when creating LaTeX output. The benefit of this
was that the ASCIIMathML syntax was pretty straightforward. The downside was
that only a handful of browsers actually support MathML, so most of the time
it was only useful for LaTeX. Many MMD users who are interested in LaTeX
output already knew LaTeX, so they sometimes preferred native math syntax,
which led to several hacks.

MultiMarkdown 3.0 does not have built in support for ASCIIMathML. In fact, I
would probably have to write a parser from scratch to do anything useful with
it, which I have little desire to do. So I came up with a compromise.

ASCIIMathML is no longer supported by MultiMarkdown. Instead, you *can* use
LaTeX to code for math within your document. When creating a LaTeX document,
the source is simply passed through, and LaTeX handles it as usual. *If* you
desire, you can add a line to your header when creating XHTML documents that
will allow [MathJax] to appropriately display your math.

Normally, MathJax *and* LaTeX supported using `\[ math \]` or `\( math \)` to
indicate that math was included. MMD stumbled on this due to some issues with
escaping, so instead we use `\\[ math \\]` and `\\( math \\)`. See an
example (Github also renders MathJax in code blocks, so you have to look into the source by editing this page):

    latex input:    mmd-article-header  
    Title:          MultiMarkdown Math Example  
    latex input:    mmd-article-begin-doc  
    latex footer:   mmd-memoir-footer  
    xhtml header:   <script type="text/javascript"
        src="http://localhost/~fletcher/math/mathjax/MathJax.js">
        </script>
                
                
    An example of math within a paragraph --- \\({e}^{i\pi }+1=0\\)
    --- easy enough.
    
    And an equation on its own:
    
    \\[ {x}_{1,2}=\frac{-b\pm \sqrt{ {b}^{2}-4ac}}{2a} \\]
    
    That's it.

You would, of course, need to change the `xhtml header` metadata to point to
your own installation of MathJax.

**Note**: MultiMarkdown doesn't actually *do* anything with the code inside
the brackets. It simply strips away the extra backslash and passes the LaTeX
source unchanged, where it is handled by MathJax *if* it's properly installed,
or by LaTeX. If you're having trouble, you can certainly email the
[MultiMarkdown Discussion List], but I do not provide support for LaTeX code.

[ASCIIMathML]:  http://www.chapman.edu/~jipsen/mathml/Asciimath.html
[MathJax]:      http://www.mathjax.org/
[MultiMarkdown Discussion List]: http://groups.google.com/group/multimarkdown/

## Definition Lists ##

MultiMarkdown has support for definition lists using the same syntax used in
[PHP Markdown Extra][]. Specifically:

    Apple
    :   Pomaceous fruit of plants of the genus Malus in 
        the family Rosaceae.
    :   An american computer company.
    
    Orange
    :   The fruit of an evergreen tree of the genus Citrus.


becomes:

> Apple
> : Pomaceous fruit of plants of the genus Malus in 
>       the family Rosaceae.
> : An american computer company.
>
> Orange
> : The fruit of an evergreen tree of the genus Citrus.

You can have more than one term per definition by placing each term on a
separate line. Each definition starts with a colon, and you can have more than
one definition per term. You may optionally have a blank line between the last
term and the first definition.

Definitions may contain other block level elements, such as lists,
blockquotes, or other definition lists.

See the [PHP Markdown Extra][] page for more information.

## Appendices ##

If you want to designate the final subgroup of chapters as appendices,  you can include an `h1` or `h2` level header (as appropriate based on your document) with the title `Appendices`.  The chapters that follow would be considered appendices when the document is converted to LaTeX using the memoir class.  Since XHTML doesn't have a concept of appendices, it has no real meaning, but would at least designate this to the reader.

## Glossaries ##

MultiMarkdown has a feature that allows footnotes to be specified as glossary
terms. It doesn't do much for XHTML documents, but the XSLT file that converts
the document into LaTeX is designed to convert these special footnotes into
glossary entries.

The glossary format for the footnotes is:

    [^glossaryfootnote]: glossary: term (optional sort key)
        The actual definition belongs on a new line, and can continue on
        just as other footnotes.

The `term` is the item that belongs in the glossary. The `sort key` is
optional, and is used to specify that the term should appear somewhere else in
the glossary (which is sorted in alphabetical order).

Unfortunately, it takes an extra step to generate the glossary when creating a
pdf from a latex file:

1. You need to have the `basic.gst` file installed, which comes with the
memoir class.

2. You need to run a special makeindex command to generate the `.glo` file:
        ``makeindex -s `kpsewhich basic.gst` -o "filename.gls" "filename.glo"``

3. Then you run the usual pdflatex command again a few times.

Alternatively, you can use the code below to create an engine file for TeXShop
(it belongs in `~/Library/TeXShop/Engines`). You can name it something like
`MemoirGlossary.engine`. Then, when processing a file that needs a glossary,
you typeset your document once with this engine, and then continue to process
it normally with the usual LaTeX engine. Your glossary should be compiled
appropriately. If you use [TeXShop][], this is the way to go.

**Note**: *Getting glossaries to work is a slightly more advanced LaTeX
feature, and might take some trial and error the first few times.*


    #!/bin/ 
    
    set path = ($path /usr/local/teTeX/bin/powerpc-apple-darwin-current 
        /usr/local/bin) # This is actually a continuation of the line above
    
    set basefile = `basename "$1" .tex`
    
    makeindex -s `kpsewhich basic.gst` -o "${basefile}.gls" "${basefile}.glo"


[TeXShop]: http://www.uoregon.edu/~koch/texshop/ "TeXShop Homepage"

## Poetry Mode ##

By default, when you have a section of text indented with a tab, MultiMarkdown
interprets this as a code block. This allows you to more exactly control the
spacing and line endings, but it also applies a monospace font in both the
XHTML and LaTeX outputs. This is the usual way of demonstrating source code in
documents.

Some authors, however, don't write about source code, but would like a way to
control line endings (when writing poetry, for example).

To accomplish this, there are several alternate XSLT files included within the
MultiMarkdown distribution that are labelled with a `poetry` filename. These
XSLT files handle the code blocks in a slightly different way to make them
more suitable for text, rather than code. I encourage you to give this a try.

At the current time, there is no way to use both formats within the same
document, except to format them manually. This may change in the future,
depending on some decisions John Gruber needs to make about the standard
Markdown syntax.

## Miscellanea ##

In addition to what is mentioned elsewhere in this document, MultiMarkdown
does a few things slightly differently:

* `&copy;` entities are converted to `&#xA9;` so that they can pass through an
  XSLT parser

* `*` and `_` are not interpreted as `<strong>` or `<em>` when they occur in
  the middle of words. This caused too many problems with URL's.

MultiMarkdown supports the conversion of colored spans of text from XHTML to
LaTeX using the xcolor package. For example:

    <span style="color:#888888">net</span>

becomes:

    {\color[HTML]{888888} net}

There is not currently a syntax shortcut for this, you have to manually add
the `<span>` information. This technique is used to support annotations from
Scrivener, for example.

