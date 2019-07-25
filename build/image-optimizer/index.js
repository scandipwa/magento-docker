/**
 * Helper for recursively generating optimised cms, slider, product and category images
 * Generates webp and low resolution sqip svg images
 */
const recursive = require("recursive-readdir");
const webp = require('webp-converter');
const sqip = require('sqip');
const path = require('path');
const fs = require('fs');

const directories = [
    {
        path: 'images/wysiwyg',
        replace_from_svg: 'wysiwyg',
        replace_to_svg: 'svg/wysiwyg',
        replace_from_webp: 'wysiwyg',
        replace_to_webp: 'webp/wysiwyg'
    },
    {
        path: 'images/scandiweb',
        replace_from_svg: 'scandiweb/slider',
        replace_to_svg: 'svg/scandiweb/slider',
        replace_from_webp: 'scandiweb/slider',
        replace_to_webp: 'webp/scandiweb/slider'
    },
    {
        path: 'images/catalog/category',
        replace_from_svg: 'catalog/category',
        replace_to_svg: 'svg/catalog/category',
        replace_from_webp: 'catalog/category',
        replace_to_webp: 'webp/catalog/category'
    },
    {
        path: 'images/catalog/product',
        replace_from_svg: 'catalog/product',
        replace_to_svg: 'svg/catalog/product',
        replace_from_webp: 'catalog/product',
        replace_to_webp: 'webp/catalog/product'
    },
];

directories.forEach((dir) => {
    recursive(dir.path, function (err, files) {
        files.forEach((file) => {

            //skip cache
            if (file.includes('cache')) {
                console.log("skipped file: ", file);
                return;
            }

            //skip non jpeg and non png images
            if (['.jpg', '.jpeg', '.png'].includes(path.extname(file)) === false) {
                console.log("skipped file: ", file);
                return;
            }

            // Skip svg images
            if (path.extname(file) !== '.svg') {
                const svgDestPath = file.replace(dir.replace_from_svg, dir.replace_to_svg).replace(path.extname(file), '.svg');

                //check if file does not exist already
                if (!fs.existsSync(svgDestPath)) {
                    fs.mkdir(path.dirname(svgDestPath), {recursive: true}, e => {
                        const result = sqip({
                            filename: file,
                        });

                        //generate svg low res placeholder
                        fs.writeFile(svgDestPath, result.final_svg, e => console.log);
                    });
                }

                //generate webp image
                const webpDestPath = file.replace(dir.replace_from_webp, dir.replace_to_webp).replace(path.extname(file), '.webp');

                //check if file does not exist already
                if (!fs.existsSync(webpDestPath)) {
                    fs.mkdir(path.dirname(webpDestPath), {recursive: true}, e => {
                        webp.cwebp(file, webpDestPath, "-q 80", (status, error) => console.log(error));
                    });
                }
            }
        })
    });
});
