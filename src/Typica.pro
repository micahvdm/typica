######################################################################
# Automatically generated by qmake (2.01a) Sat May 23 23:41:13 2009
######################################################################

QT += script
QT += xml
QT += sql
QT += xmlpatterns
QT += scripttools
QT += webkit

include(3rdparty/qextserialport/src/qextserialport.pri)

TEMPLATE = app
TARGET =
DEPENDPATH += .

# Input
HEADERS += moc_typica.cpp \
    helpmenu.h \
    abouttypica.h \
    units.h \
    webview.h \
    webelement.h \
    scale.h \
    draglabel.h \
    clock.h
SOURCES += typica.cpp \
    helpmenu.cpp \
    abouttypica.cpp \
    units.cpp \
    webview.cpp \
    webelement.cpp \
    scale.cpp \
    draglabel.cpp \
    clock.cpp

RESOURCES += \
    resources.qrc

RC_FILE = typica.rc
ICON = resources/icons/appicons/logo.icns
QMAKE_INFO_PLIST = resources/Info.plist
