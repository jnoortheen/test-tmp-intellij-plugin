package com.github.jnoortheen.testtmpintellijplugin.services

import com.intellij.openapi.project.Project
import com.github.jnoortheen.testtmpintellijplugin.MyBundle

class MyProjectService(project: Project) {

    init {
        println(MyBundle.message("projectService", project.name))
    }
}
