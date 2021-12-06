mod util;

fn calculate_consumption(vec: &Vec<&str>) -> (i32, i32) {
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

        if ones >= zeros {
            gamma = gamma | 1;
        }
    }

    // Bitwise not creates too many 1s on the left of the epsilon value
    // so we need to create a mask
    let full_mask = !0 << size;
    let epsilon = !gamma ^ full_mask;
    return (gamma, epsilon);
}

fn from_bin(x: &str) -> i32 {
    return i32::from_str_radix(x, 2).unwrap();
}

fn calculate_ratings(vec: &Vec<&str>) -> (i32, i32) {
    // Calculate this twice for edge cases sadly
    // I'm sure there is a way to avoid this though.

    // Get the initial size
    let size = vec[0].len();
    let mut oxy = vec.clone();
    let mut co2 = vec.clone();

    // For each bit left
    for bit in (0..size).rev() {
        // Calculate most common of what is left
        // Get position mask
        let bit_mask = 1 << bit;

        // Flip the bits of the target one we're going to filter
        // if the bit isn't set, so that we can still use the single
        // positive bit on the bit mask to filter
        if oxy.len() > 1 {
            let (gamma, _) = calculate_consumption(&oxy);
            let is_set = gamma & bit_mask > 0;

            if is_set {
                oxy.retain(|&x| (from_bin(x) & bit_mask) > 0);
            } else {
                oxy.retain(|&x| (!from_bin(x) & bit_mask) > 0);
            }
        }

        // repeat with inverse of gamma (which is epsilon)
        // as well as the co2 vec

        if co2.len() > 1 {
            let (_, eps) = calculate_consumption(&co2);
            let is_set = eps & bit_mask > 0;

            if is_set {
                co2.retain(|&x| (from_bin(x) & bit_mask) > 0);
            } else {
                co2.retain(|&x| (!from_bin(x) & bit_mask) > 0);
            }
        }
    }

    return (from_bin(oxy[0]), from_bin(co2[0]));
}

fn main() {
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

    let (g, e) = calculate_consumption(&sample);
    println!("{} should be 198", g * e);

    let (o, c) = calculate_ratings(&sample);
    println!("{} should be 230", o * c);

    let (g, e) = calculate_consumption(&_input);
    println!("part 1 answer is {}", g * e);

    let (o, c) = calculate_ratings(&_input);
    println!("part 2 answer is {} ", o * c);

}
