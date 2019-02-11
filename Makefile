# Variables
# ---------

family  := Oxanium
version := 1.000
styles  := ExtraLight Light Regular Medium SemiBold Bold ExtraBold
formats := ttf woff woff2
fonts   := $(foreach s,$(styles), $(foreach f,$(formats), fonts/$(f)/$(family)-$(s).$(f)))


# Convenience rules
# -----------------

.PHONY: all
all: $(fonts)

.PHONY: clean
clean:
	@ rm -fr temp fonts


# File rules
# ----------

fonts/ttf/%.ttf: \
	temp/ttf/%.ttf \
	temp/fea/%.fea
		@ mkdir -p $(@D)
		@ ./tools/ttf-clean.py $^ $@

fonts/woff/%.woff: \
	fonts/ttf/%.ttf
		@ mkdir -p $(@D)
		@ ./tools/ttf-woff.py $^ $@

fonts/woff2/%.woff2: \
	fonts/ttf/%.ttf
		@ mkdir -p $(@D)
		@ ./tools/ttf-woff.py $^ $@

.PRECIOUS: temp/ttf/%.ttf
temp/ttf/%.ttf: \
	sources/sfd/%.sfd \
	temp/fea/%.fea \
	temp/hti/%.hti
		@ mkdir -p $(@D)
		@ ./tools/sfd-ttf.py $^ $(version) $@

.PRECIOUS: temp/fea/$(family)-%.fea
temp/fea/$(family)-%.fea: \
	sources/fea/$(family)-All-classes.fea \
	sources/fea/$(family)-All-features.fea \
	sources/fea/$(family)-%-marks.fea
		@ mkdir -p $(@D)
		@ cat $^ > $@

.PRECIOUS: temp/hti/$(family)-%.hti
temp/hti/$(family)-%.hti: \
	sources/hti/$(family)-All-tables.hti \
	sources/hti/$(family)-All-fpgm.hti \
	sources/hti/$(family)-All-prep.hti \
	sources/hti/$(family)-All-glyphs.hti
		@ mkdir -p $(@D)
		@ cat $^ | sed 's/#if$* //' > $@
