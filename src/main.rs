#[macro_use] extern crate rocket;

#[get("/")]
fn hello() -> &'static str {
    "Hello from Rust!"
}

use rocket_prometheus::PrometheusMetrics;

#[launch]
fn rocket() -> _ {
    let prometheus = PrometheusMetrics::new();
    rocket::build()
        .attach(prometheus.clone())
        .mount("/metrics", prometheus)
        .mount("/api/v1/rocket", routes![hello])
}
