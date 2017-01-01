package io.stormcat

import spark.Spark.*

fun main(args: Array<String>) {

    get("/echo", { req, res ->
        "Hello, ${req.queryParams("name")}!"
    })

}
