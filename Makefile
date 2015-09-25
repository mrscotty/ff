test:
	prove -Ilib t/*.t

vtest:
	prove --verbose -Ilib t/*.t
