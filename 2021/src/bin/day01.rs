mod util;

use std::io::Result;

fn main() -> Result<()> {
    let input: Vec<i32> = util::load_file_split("input/day01.txt").unwrap()
        .iter()
        .filter(|x| !x.is_empty())
        .map(|x| x.parse::<i32>().unwrap())
        .collect();

    let sample = vec![
        199,
        200,
        208,
        210,
        200,
        207,
        240,
        269,
        260,
        263,
    ];

    // Part 1
    let ans = count_increases(&sample);
    println!("{} should be 7", ans);

    let ans = count_increases(&input);
    println!("the answer is {}", ans);

    let ans = count_increases_sliding(&sample, 3);
    println!("{} shoud be 5", ans);

    let ans = count_increases_sliding(&input, 3);
    println!("the answer is {}", ans);

    return Ok(());
}

fn count_increases(vec: &Vec<i32>) -> i32 {
    let mut ans = 0;
    let mut iter = vec.iter();
    let mut current = iter.next();

    loop {
        let next = iter.next();
        if next.is_none() {
            break
        }
        if next > current {
            ans += 1
        }
        current = next;
    }
    return ans;
}

fn count_increases_sliding(vec: &Vec<i32>, window: usize) -> i32 {
    let iter = vec.windows(window).map(|x| x.iter().sum::<i32>());
    return count_increases(&iter.collect());
}
