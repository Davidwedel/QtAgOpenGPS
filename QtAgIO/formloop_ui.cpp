#include <QQuickView>
#include <QQuickWidget>
#include <QQmlContext>
#include <QScreen>
#include <QGuiApplication>
#include <QQmlEngine>
#include "qmlutil.h"
#include "formloop.h"
#include "interfaceproperty.h"

void FormLoop::setupGUI()
{
    //Load the QML UI and display it in the main area of the GUI
    setProperty("title", "QtAgIO");

    //load the QML into a view
    engine.rootContext()->setContextProperty("screenPixelDensity",QGuiApplication::primaryScreen()->physicalDotsPerInch() * QGuiApplication::primaryScreen()->devicePixelRatio());
    engine.rootContext()->setContextProperty("mainForm", this);
    engine.rootContext()->setContextProperty("prefix", ":");
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));



    if (engine.rootObjects().isEmpty())
    {
        qDebug() << "Failed to load QML file";
        return;
    }
    else
    {
        qDebug() << "Displaying QML File";
    }

    QList<QObject*> root_context = engine.rootObjects();

    qml_root = root_context.first();

    //have to do this for each Interface and supported data type.
    InterfaceProperty<AgIOInterface, int>::set_qml_root(qmlItem(qml_root, "agio"));
    InterfaceProperty<AgIOInterface, uint>::set_qml_root(qmlItem(qml_root, "agio"));
    InterfaceProperty<AgIOInterface, bool>::set_qml_root(qmlItem(qml_root, "agio"));
    InterfaceProperty<AgIOInterface, double>::set_qml_root(qmlItem(qml_root, "agio"));
    //InterfaceProperty<AgIOInterface, btnStates>::set_qml_root(qmlItem(qml_root, "aog"));

}
