.PHONY: all clean report

all: index.html

analysis/data:
	mkdir -p analysis/data/raw analysis/data/clean

analysis/data/raw:
	mkdir -p analysis/data/raw

analysis/data/clean:
	mkdir -p analysis/data/clean

analysis/output:
	mkdir -p analysis/output

results/eda:
	mkdir -p results/eda

results/model:
	mkdir -p results/model

docs:
	mkdir -p docs

docs/.nojekyll: | docs
	touch docs/.nojekyll

analysis/data/raw/adult_raw.csv: analysis/01-download_data.R | analysis/data/raw
	Rscript analysis/01-download_data.R --url="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data" --output=analysis/data/raw/adult_raw.csv

analysis/data/clean/adult_clean.csv: analysis/02-clean_data.R analysis/data/raw/adult_raw.csv | analysis/data/clean
	Rscript analysis/02-clean_data.R --input=analysis/data/raw/adult_raw.csv --output=analysis/data/clean/adult_clean.csv

analysis/data/clean/adult_training.csv analysis/data/clean/adult_testing.csv: analysis/03-training_split.R analysis/data/clean/adult_clean.csv | analysis/data/clean
	Rscript analysis/03-training_split.R --input=analysis/data/clean/adult_clean.csv --output_train=analysis/data/clean/adult_training.csv --output_test=analysis/data/clean/adult_testing.csv

results/eda/pairwise_plot.png results/eda/summary_statistics.csv: analysis/04-eda.R analysis/data/clean/adult_training.csv | results/eda
	Rscript analysis/04-eda.R --input=analysis/data/clean/adult_training.csv --output_plot=results/eda/pairwise_plot.png --output_table=results/eda/summary_statistics.csv

results/model/log_reg_model.RDS results/model/roc_plot.png: analysis/05-model.R analysis/data/clean/adult_training.csv | results/model
	Rscript analysis/05-model.R --input=analysis/data/clean/adult_training.csv --output_model=results/model/log_reg_model.RDS --output_plot=results/model/roc_plot.png

results/model/conf_matrix_plot.png results/model/summary_statistics.csv: analysis/06-final_results.R analysis/data/clean/adult_testing.csv results/model/log_reg_model.RDS | results/model
	Rscript analysis/06-final_results.R --input_data=analysis/data/clean/adult_testing.csv --input_model=results/model/log_reg_model.RDS --output_plot=results/model/conf_matrix_plot.png --output_table=results/model/summary_statistics.csv

index.html: report/report.qmd results/eda/pairwise_plot.png results/model/roc_plot.png results/model/conf_matrix_plot.png results/model/summary_statistics.csv docs docs/.nojekyll
	quarto render report/report.qmd --to html
	mv report/report.html docs/index.html

clean:
	rm -rf docs
	rm -rf results/eda
	rm -rf results/model
	rm -f analysis/data/clean/*
	rm -f Rplots.pdf