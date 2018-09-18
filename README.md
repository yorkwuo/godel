# Godel
Godel is a solution for collecting, processing, presenting and connecting information.

# 在 windows 下使用
你需要安装 Firefox 和 Cygwin. 
安装 Cygwin 时，在 Cygwin 的安装界面里，请勾选安装 git, tcsh, vim, tcl

打开 Cygwin terminal, 用 git clone下载 godel, 然后 source cshrc 完成环境设定。

	% mkdir github
	% cd github
	% git clone https://github.com/yorkwuo/godel
	% cd godel
	% source cshrc

指定如下的 alias, 让 firefox 可以在 cygwin terminal 中打开。 如果你的 firefox 安装在
不同的路径，请跟着修改。

	% alias firefox "/cygdrive/c/Program\ Files/Mozilla\ Firefox/firefox.exe \!* &"

试着用 newpage 命令创建一个名叫 test 的 page。在 Godel 的设计中，一个 page 就等同一个目录。

	% mkdir test
	% cd test
	% newpage .

打开 pagelist page. 你会看到刚刚创建的页面： test.

	% pagelist

点击 Edit, 你可以用gnotes写你的笔记。

	ghtm_top_bar
	ghtm_list_files *

	gnotes {
	This is a test.
	这是一个测试页。
	}

存档之后，用指令 gd 重画这一页，然后在 firefox reload page，你就可以看到你刚刚的笔记。

	% gd




