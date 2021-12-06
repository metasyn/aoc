mod util;

use std::fmt;

#[derive(Clone)]
struct BingoCard {
    values: Vec<i32>,
    marked: Vec<bool>,
    bingo: bool,
    score: i32,
}

impl BingoCard {
    fn update(&mut self, number: &i32) -> bool {
        for (i, x) in self.values.iter().enumerate() {
            if number == x {
                self.marked[i] = true;
            }
        }
        self.check_rows();
        self.check_columns();
        if self.bingo {
            self.score = self.unmarked_sum() * number
        };
        return self.bingo;
    }

    fn check_rows(&mut self) {
        // Get index of starting row
        for i in vec![0, 5, 10, 15, 20] {
            let items = &self.marked[i..i+5];
            if items.iter().all(|&x| x == true) {
                self.bingo = true;
            }
        }
    }

    fn check_columns(&mut self) {
        for i in 0..5 {
            let mut indices = vec![i];
            for j in 1..5 {
                indices.push((j * 5) + i)
            }
            let mut total = 0;
            for index in indices {
                if self.marked[index] == true{
                    total += 1
                }
            }
            if total == 5 {
                self.bingo = true;
                return;
            }
        }
    }

    fn unmarked_sum(&mut self) -> i32 {
        let mut sum = 0;
        for i in 0..self.marked.len() {
            if self.marked[i] == false {
                sum += self.values[i];
            }
        }
        return sum;
    }
}

impl fmt::Debug for BingoCard {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        writeln!(f, "\nScore: {}", self.score).unwrap();
        for i in 0..25 {
            if self.marked[i] {
                write!(f, "[{:>2}] ", self.values[i]).unwrap();
            } else {
                write!(f, " {:>2}  ", self.values[i]).unwrap();
            }

            if (i + 1) % 5 == 0 {
                write!(f, "\n").unwrap();
            }
        }
        Ok(())
    }
}

fn load_file(path: &str) -> (Vec<i32>, Vec<BingoCard>) {
    let sample = util::load_file(path).unwrap();
    let items = sample.split("\n\n").collect::<Vec<&str>>();
    let numbers = items[0]
        .split(",")
        .map(|x| x.parse::<i32>().unwrap())
        .collect::<Vec<i32>>();

    let cards = items[1..]
        .iter() .map(|x| x.split_whitespace().collect::<Vec<&str>>()) .map(|s| {
            let values = s
                .iter()
                .map(|x| x.replace("\n", "").parse::<i32>().unwrap())
                .collect::<Vec<i32>>();
            let marked: Vec<bool> = vec![false; values.len()];
            let bingo = false;
            return BingoCard {
                values,
                marked,
                bingo,
                score: 0,
            };
        })
        .collect::<Vec<BingoCard>>();

    return (numbers, cards);
}

fn get_winning_cards(numbers: &Vec<i32>, mut cards: Vec<BingoCard>) -> Vec<BingoCard> {
    let mut output = vec![];

    for num in numbers {
        for card in &mut cards {
            card.update(&num);
            if card.bingo {
                let copy = card.clone();
                output.push(copy);
            }
        }
        cards.retain(|x| !x.bingo);
    }

    return output;
}

fn main() {
    let (numbers, cards) = load_file("input/day04.txt");
    println!(
        "Nunber of Bingo Numbers: {:?}\nNumber of cards: {:?}",
        numbers.len(),
        cards.len()
    );


    let cards = get_winning_cards(&numbers, cards);
    println!("{}", "=".repeat(70));
    println!("{:?}\n\n{:?}", cards[0], cards[cards.len()-1]);
}
