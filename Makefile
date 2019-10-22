# Variables
# ---------

family  := Oxanium
version := 1.001
styles  := ExtraLight Light Regular Medium SemiBold Bold ExtraBold

fonts   := $(foreach s,$(styles), fonts/$(family)-$(s).ttf)
woff    := $(foreach s,$(styles), webfonts/$(family)-$(s).woff)
woff2   := $(foreach s,$(styles), webfonts/$(family)-$(s).woff2)


# Convenience rules
# -----------------

.PHONY: fonts
fonts: $(fonts)

.PHONY: webfonts
webfonts: $(woff) $(woff2)

.PHONY: clean
clean:
	@ rm -fr temp webfonts


# File rules
# ----------

fonts/%.ttf: temp/%.ttf temp/%.fea
	@ mkdir -p $(@D)
	@ ./tools/ttf-clean.py $^ $@

webfonts/%.woff: fonts/%.ttf
	@ mkdir -p $(@D)
	@ ./tools/ttf-woff.py $^ $@

webfonts/%.woff2: fonts/%.ttf
	@ mkdir -p $(@D)
	@ ./tools/ttf-woff.py $^ $@

.PRECIOUS: temp/%.ttf
temp/%.ttf: \
	sources/sfd/%.sfd \
	temp/%.fea \
	temp/%.hti
		@ mkdir -p $(@D)
		@ ./tools/sfd-ttf.py $^ $(version) $@

.PRECIOUS: temp/$(family)-%.fea
temp/$(family)-%.fea: \
	sources/fea/$(family)-All-classes.fea \
	sources/fea/$(family)-All-features.fea \
	sources/fea/$(family)-%-marks.fea
		@ mkdir -p $(@D)
		@ cat $^ > $@

.PRECIOUS: temp/$(family)-%.hti
temp/$(family)-%.hti: \
	sources/hti/$(family)-All-tables.hti \
	sources/hti/$(family)-All-fpgm.hti \
	sources/hti/$(family)-All-prep.hti \
	sources/hti/$(family)-All-glyphs.hti
		@ mkdir -p $(@D)
		@ cat $^ | sed 's/#if$* //' > $@
