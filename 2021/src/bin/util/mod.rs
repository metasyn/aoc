use std::fs::File;
use std::io::{BufReader, Read, Result};
use std::path::Path;

pub fn load_file<P: AsRef<Path>>(path: P) -> Result<String> {
    let file = File::open(path)?;
    let mut buf_reader = BufReader::new(file);
    let mut contents = String::new();
    buf_reader.read_to_string(&mut contents)?;
    return Ok(contents);
}

pub fn load_file_split<P: AsRef<Path>>(path: P) -> Result<Vec<String>> {
    return Ok(load_file(path)
        .unwrap()
        .split("\n")
        .map(|x| x.to_string())
        .collect());
}
