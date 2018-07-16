#!/usr/bin/python

#
# Description
# -----------
# Print a config with colors
#
# Colors used
# -----------
# # Comment : Black
# [section] : Magenta
# key 		: Yellow
# value 	: Green
# @Param 	: Cyan
# Misc		: Red
#
# Parameters:
# -----------
# PARAM1: config filename
#


from __future__ import print_function
from colorama import init, Fore, Back, Style
import sys
import codecs
import re


def main(argv):
	if len(argv) != 1:
		print('Error: No Git config file found in parameters!')
		sys.exit(2)
	print_gitconfig(argv[0])


def print_gitconfig(file_name):
	print('Git Config: ' + Style.BRIGHT + Fore.CYAN + file_name)
	with codecs.open(file_name, encoding='utf-8', mode='r') as f:
		lines = f.readlines()
		lines = [line.replace("\n", "").replace("\r", "").replace("\t", "") for line in lines]
		for line in lines:
			print_line(line)
	print(Fore.RESET + Back.RESET + Style.RESET_ALL)


def print_line(line):
	if re.match('^\[.*\]$', line) != None:
		print_section(line)
	elif re.match('^#', line) != None:
		print_comment(line)
	else:
		print_key_value(line)


def print_section(section):
	print()
	print(Fore.MAGENTA + section)


def print_comment(comment):
	print(Fore.BLACK + comment)


def print_key_value(key_value):
	equal = key_value.find('=')
	if equal == -1:
		print(Fore.RED + key_value)
	else:
		key, value = key_value[:equal], key_value[equal+1:]
		comment = ''
		sharp = value.find('#')
		if sharp != -1:
			value, comment = value[:sharp], value[sharp:]
			for param in re.findall('@\w+', comment):
				comment = comment.replace(param, Fore.CYAN + param + Fore.BLACK)
		print(' ' + Fore.YELLOW + key.strip() + ' ' + Fore.GREEN + value.strip() + ' ' + Fore.BLACK + comment)


if __name__ == "__main__":
	init()
	main(sys.argv[1:])
