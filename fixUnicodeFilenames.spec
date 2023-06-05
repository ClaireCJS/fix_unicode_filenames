# -*- mode: python ; coding: utf-8 -*-


from PyInstaller.utils.hooks import collect_data_files, collect_submodules
from PyInstaller.building.datastruct import Tree

#pythainlp_datas = Tree('C:/ProgramData/anaconda3/envs/fuf/Lib/site-packages/pythainlp/corpus', prefix='pythainlp/corpus')
#pythainlp_datas_tuples = [(str(i[0]), i[1]) for i in pythainlp_datas]
pythainlp_datas_tuples = collect_data_files('pythainlp') + collect_data_files('pythainlp.corpus')

#datas = pythainlp_datas_tuples
datas = collect_data_files('pythainlp') + pythainlp_datas_tuples

#print (f"\n* dlls are {str(dlls)}\n")
#print (f"* binaries are {str(binaries)}\n")
#print (f"* pythainlp_datas_tuples are {str(pythainlp_datas_tuples)}\n")
print (f"* datas are {str(datas)}\n")

block_cipher = None

a = Analysis(
    ['fixUnicodeFilenames.py'],
    pathex=['c:/fuf'],
    #binaries=[('c:/fuf/dlls/*','.')],	#worked! but still gave DLL error on Carolyn's computer
    binaries=[('c:/fuf/python310.dll*','.')],
    datas=datas,
    hiddenimports=['tzdata'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='fixUnicodeFilenames',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
