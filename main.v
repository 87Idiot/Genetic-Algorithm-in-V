module main

import (
	rand
	time
)

const (
	TARGET = 'I Love V. Alex too <3 (I\'m not gay)'
	GENES  = ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~'
	MUTATION_RATE = 25
	POPULATION_SIZE = 100
)

fn random_gene() byte {
	return GENES[ rand.next(GENES.len) ]
}

fn random_chromosome(length int) string {

	mut res := ''

	for _ in 0..length {
		res += random_gene().str()
	}

	return res

}

fn create_generation(population_size, chromosome_length int) []string {

	mut res := []string

	for _ in 0..population_size {
		res << random_chromosome(chromosome_length)
	}

	return res

}

fn calculate_fitness(individual, target string) int {

	mut fitness := 0

	for i in 0..target.len {
		if individual[i] != target[i] {
			fitness++
		}
	}

	return fitness

}

fn compare_individual(a, b &string) int {

	fit_a := calculate_fitness(a, TARGET)
	fit_b := calculate_fitness(b, TARGET)

	return if fit_a < fit_b {
		-1
	} else if fit_a == fit_b {
		0
	} else {
		1
	}

}

fn sort_generation(generation []string) []string {

	mut res := generation.clone()
	res.sort_with_compare(compare_individual)

	return res

}

fn crossover(a, b string) string {

	mut child := ''

	for i in 0..a.len {

		if rand.next(100) < 50 {
			child += a[i].str()
		} else {
			child += b[i].str()
		}

	}

	return child

}

fn mutate(ind string) string {

	if rand.next(100) < MUTATION_RATE {
		position := rand.next(ind.len)
		return ind[0..position] + random_gene().str() + ind[(position+1)..ind.len]
	} else {
		return ind
	}

}

fn main() {

	rand.seed(time.now().uni)

	mut generation := create_generation(POPULATION_SIZE, TARGET.len)
	generation = sort_generation(generation)

	for calculate_fitness(generation[0], TARGET) != 0 {

		mut new_generation := []string

		top := POPULATION_SIZE / 10 // top 10%

		new_generation << generation[0..top]

		for _ in 0..(POPULATION_SIZE - top) {

			a := generation[ rand.next(POPULATION_SIZE) ]
			b := generation[ rand.next(POPULATION_SIZE) ]

			new_generation << crossover(a, b)

		}

		for i in 0..new_generation.len {
			new_generation[i] = mutate(new_generation[i])
		}

		generation = sort_generation(new_generation)
		println('${generation[0]} -> ${calculate_fitness(generation[0], TARGET)}')

	}

}