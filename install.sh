##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure and implement callbacks in this file
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=false

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# The installation framework will export some variables and functions.
# You should use these variables and functions for installation.
#
# ! DO NOT use any Magisk internal paths as those are NOT public API.
# ! DO NOT use other functions in util_functions.sh as they are NOT public API.
# ! Non public APIs are not guranteed to maintain compatibility between releases.
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################
##########################################################################################
# If you need boot scripts, DO NOT use general boot scripts (post-fs-data.d/service.d)
# ONLY use module scripts as it respects the module status (remove/disable) and is
# guaranteed to maintain the same behavior in future Magisk releases.
# Enable boot scripts by setting the flags in the config section above.
##########################################################################################

# Set what you want to display when installing your module

print_modname() {
  ui_print "*******************************"
  ui_print "    MiK's Development Module   "
  ui_print "*******************************"
}

# Copy/extract your module files into $MODPATH in on_install.

on_install() {
  # The following is the default implementation: extract $ZIPFILE/system to $MODPATH
  # Extend/change the logic to whatever you want
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

  # 将不同功能逻辑编写为带注释函数
  # 归类于本文件底部自定义函数区域
  # 在此处调用各功能逻辑并明确注释
  # 禁止在此处编写功能逻辑

  ## 调用示例功能安装逻辑
  custom_on_install_function__example
  
  ## 调用字体功能安装逻辑
  custom_on_install_function__fonts
}

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0644

  # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644

  # 同 on_install 内注释

  ## 调用示例功能权限设置
  custom_set_permissions_function__example
  
  ## 调用字体功能权限设置
  custom_set_permissions_function__fonts
}

# You can add more functions to assist your custom script code

### 自定义示例开始
# # 安装逻辑
#   无参数
#   无返回值
#   输出文本
custom_on_install_function__example() {
  ui_print "--示例功能逻辑输出开始#"
  ui_print "- 设备架构: $ARCH"
  ui_print "- 系统 API 级别: $API"
  ui_print "- Magisk 版本: $MAGISK_VER"
  ui_print "- ZIPFILE: $ZIPFILE"
  ui_print "- TMPDIR: $TMPDIR"
  ui_print "- MODPATH: $MODPATH"
  ui_print "--示例功能逻辑输出结束#"
}
# # 权限设置
custom_set_permissions_function__example() {
  ui_print "--示例功能无需设置权限#"
}
### 自定义示例结束

### 字体开始
# # 安装逻辑
#   无参数
#   无返回值
#   补全 /system/etc/fonts.xml 中的字重，抽取对应字体文件到 /system/fonts 目录下
custom_on_install_function__fonts() {
  ui_print "--字体功能开始安装#"
  # 准备相关变量
  if [[ -d /sbin/.magisk/mirror ]]; then
    _MIRRORDIR=/sbin/.magisk/mirror
  elif [[ -d /sbin/.core/mirror ]]; then
    _MIRRORDIR=/sbin/.core/mirror
  else
    unset _MIRRORDIR
  fi

  FILE=fonts.xml
  FILEPATH=/system/etc/
  FONTFILESDIR=/system/fonts/

  if [ -f $_MIRRORDIR$FILEPATH$FILE ]; then
    mkdir -p $MODPATH$FILEPATH
    cp -af $_MIRRORDIR$FILEPATH$FILE $MODPATH$FILEPATH$FILE
    mkdir -p $MODPATH$FONTFILESDIR
    if [ "$(cat $FILEPATH$FILE |grep '<family lang="zh-Hans">')" ]; then
      ui_print "- Process zh-Hans"
      sed -i '/<family lang="zh-Hans">/,/<\/family>/ {
        s/<family lang="zh-Hans">/<family lang="zh-Hans">\n<font weight="100" style="normal">NotoSansCJKsc-Thin.otf<\/font>\n<font weight="300" style="normal">NotoSansCJKsc-Light.otf<\/font>\n<font weight="350" style="normal">NotoSansCJKsc-DemiLight.otf<\/font>\n<font weight="400" style="normal">NotoSansCJKsc-Regular.otf<\/font>\n<font weight="500" style="normal">NotoSansCJKsc-Medium.otf<\/font>\n<font weight="700" style="normal">NotoSansCJKsc-Bold.otf<\/font>\n<font weight="900" style="normal">NotoSansCJKsc-Black.otf<\/font>\n<\/family>\n<family lang="zh-Hans">/;
      }' $MODPATH$FILEPATH$FILE
      ui_print "- Copy zh-Hans otf files"
      unzip -oj "$ZIPFILE" "common/system/fonts/NotoSansCJKsc-*" -d $MODPATH$FONTFILESDIR >&2
    fi
    if [ "$(cat $FILEPATH$FILE |grep '<family lang="zh-Hant">')" ]; then
      ui_print "- Process zh-Hant"
      #sed -i
    fi
    if [ "$(cat $FILEPATH$FILE |grep '<family lang="ja">')" ]; then
      ui_print "- Process ja"
      #sed -i
    fi
    if [ "$(cat $FILEPATH$FILE |grep '<family lang="ko">')" ]; then
      ui_print "- Process ko"
      #sed -i
    fi
  else
    ui_print "--字体功能安装失败(无法获取原始 fonts.xml)#"
  fi
}
# # 权限设置
custom_set_permissions_function__fonts() {
  ui_print "--字体功能无需设置权限#"
}
### 字体结束
