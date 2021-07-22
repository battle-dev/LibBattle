local LIBBATTLE, VERSION = "LibBattle", 1

assert(LibStub, LIBBATTLE .. " requires LibStub")

local libBattle = LibStub:NewLibrary(LIBBATTLE, VERSION)

_G[LIBBATTLE] = LibBattle
