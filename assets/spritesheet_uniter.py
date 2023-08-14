from os import listdir, mkdir, path

from PIL import Image


mkdir("mech_anims")

for mech_type in ["trooper", "destroyer", "gunner", "mite", "walker"]:
    mkdir(f"mech_anims/{mech_type}")
    sprite_path = f"sprites/mech/png/{mech_type}"

    animations = {}


    for filename in (path.join(sprite_path, f) for f in listdir(sprite_path) if path.isfile(path.join(sprite_path, f))):
        if not filename.endswith(".png"):
            continue
        animation = filename.split("/")[-1].split("__")[0]
        animations.setdefault(animation, [])
        animations[animation].append(filename)


    for animation in animations:
        result_animation = Image.new("RGBA", (6400, 640), (0, 0, 0, 0))
        for index, frame in enumerate(sorted(animations[animation])):
            with Image.open(frame) as img:
                position = (640 - img.size[0]) // 2 + index * 640, (640 - img.size[1]) // 2
                result_animation.paste(img, position)
        result_animation.save(f"mech_anims/{mech_type}/{animation}.png")
