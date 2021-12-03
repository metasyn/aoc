mod util;

fn calculate_consumption(vec: &Vec<&str>) -> i32 {
    let size = vec[0].len();
    let mut gamma = 0;

    for bit in 0..size {
        // New bit
        gamma = gamma << 1;

        let mut zeros = 0;
        let mut ones = 0;

        for v in vec {
            if v.chars().nth(bit).unwrap() == '0' {
                zeros += 1
            } else {
                ones += 1
            }
        }

        if ones > zeros {
            gamma = gamma | 1;
        }
    }

    // Bitwise not creates too many 1s on the left of the epsilon value
    // so we need to create a mask
    let full_mask = !0 << size;
    let epsilon = !gamma ^ full_mask;
    return epsilon * gamma;
}

fn main() -> Result<(), ()> {
    let raw = util::load_file_split("input/day03.txt").unwrap();
    let _input: Vec<&str> = raw
        .iter()
        .filter(|x| !x.is_empty())
        .map(|x| x.as_str())
        .collect();

    let sample = vec![
        "00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000", "11001",
        "00010", "01010",
    ];

    let ans = calculate_consumption(&sample);
    println!("{} should be 198", ans);

    let ans = calculate_consumption(&_input);
    println!("part 1 answer is {}", ans);

    return Ok(());
}
