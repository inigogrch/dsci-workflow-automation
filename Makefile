.PHONY: all clean report

all: analysis/data/clean_data.csv \
     analysis/output/eda_plot.png \
     analysis/output/final_model.rds \
     analysis/output/model_auc.png \
     analysis/output/conf_matrix.png \
     analysis/output/final_metrics.csv \
     index.html \
     docs/.nojekyll

analysis/data:
	mkdir -p analysis/data/raw analysis/data/clean

analysis/output:
	mkdir -p analysis/output

docs:
	mkdir -p docs

docs/.nojekyll: | docs
	touch docs/.nojekyll

analysis/data/raw/adult.data: analysis/01-download_data.R | analysis/data
	Rscript analysis/01-download_data.R \
	    --url="https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data" \
	    --output=analysis/data/raw/adult.data

analysis/data/clean_data.csv: analysis/02-clean_data.R analysis/data/raw/adult.data | analysis/data
	Rscript analysis/02-clean_data.R --input=analysis/data/raw/adult.data \
	    --output=analysis/data/clean_data.csv

analysis/output/eda_plot.png: analysis/03-eda.R analysis/data/clean_data.csv | analysis/output
	Rscript analysis/03-eda.R --input=analysis/data/clean_data.csv \
	    --output=analysis/output/eda_plot.png

analysis/output/final_model.rds analysis/output/model_auc.png: analysis/05-model.R analysis/data/clean_data.csv | analysis/output
	Rscript analysis/05-model.R --input=analysis/data/clean_data.csv \
	    --output_model=analysis/output/final_model.rds \
	    --output_plot=analysis/output/model_auc.png

analysis/output/conf_matrix.png analysis/output/final_metrics.csv: analysis/06-final_results.R analysis/data/clean_data.csv analysis/output/final_model.rds | analysis/output
	Rscript analysis/06-final_results.R --input_data=analysis/data/clean_data.csv \
	    --input_model=analysis/output/final_model.rds \
	    --output_plot=analysis/output/conf_matrix.png \
	    --output_table=analysis/output/final_metrics.csv

index.html: report/report.qmd analysis/output/eda_plot.png analysis/output/model_auc.png analysis/output/conf_matrix.png analysis/output/final_metrics.csv docs
	quarto render report/report.qmd --to html
	mv report/report.html docs/index.html

clean:
	rm -f analysis/output/*
	rm -f analysis/data/clean/*
	rm -rf docs/*
	rm -f Rplots.pdf