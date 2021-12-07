mod util;

fn main() {
    let path = "day.sample";
    let sample = util::load_file(path).unwrap();
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
    }
}
