# Untrusted Lab

Play **Untrusted**, a puzzle adventure where every level is unbeatable as
loaded and the only way out is to rewrite the JavaScript that runs it. The
game runs inside one small container; you play it in your browser.

The game is by Alex Nisnevich and Greg Shuflin
([AlexNisnevich/untrusted](https://github.com/AlexNisnevich/untrusted)); this
repo packages it as a ready-to-use dev container. See [Credits](#credits).

## Setup

You need **Docker Desktop** and **VS Code** installed.

1. **Start Docker Desktop** and wait until it says it's running (whale icon
   in the taskbar/menu bar stops animating).

2. **Install the Dev Containers extension** in VS Code: open the Extensions
   view (`Ctrl+Shift+X`, or `Cmd+Shift+X` on Mac), search **Dev Containers**,
   and install the one by Microsoft.

3. **Get the code** into a normal folder, *not* inside OneDrive, iCloud or
   Dropbox:

   ```bash
   git clone https://github.com/srikarb-jpg/untrusted.git
   ```

   It's about 430 MB, mostly the game's soundtrack, so the download takes a
   few minutes. No git? On the GitHub page click **Code → Download ZIP** and
   unzip it.

4. **Open the `untrusted` folder in VS Code** (**File → Open Folder…**).

5. **Reopen in Container.** Click **Reopen in Container** in the pop-up at the
   bottom right. If you missed it, press `F1`, type
   `Dev Containers: Reopen in Container`, and press Enter.

   The first time takes a minute or two while the container downloads. It
   then runs `make` once to build the game. When it's done, the bottom-left
   corner of VS Code says **Dev Container: Untrusted**.

6. **Check it works.** Open a terminal in VS Code (**Terminal → New
   Terminal**). It opens *inside* the container. Run:

   ```bash
   python -m http.server 8000
   ```

   You should see `Serving HTTP on 0.0.0.0 port 8000 ...` and then nothing
   else. That's correct: the server is running and waiting for your browser.

7. **Play.** Open **http://localhost:8000** in your browser. You need an
   internet connection: the page loads one library (jQuery) from the web.

You're set up. Next time, just open the folder in VS Code and it reconnects
to the container automatically.

## Tutorial

Every command below runs in a terminal **inside the container**. If the
bottom-left corner of VS Code doesn't say **Dev Container**, you're on your
own machine; run `Dev Containers: Reopen in Container` first.

### 1. Start and stop the game

```bash
python -m http.server 8000     # start; leave this terminal running
```

Open **http://localhost:8000**. Each time the browser loads a file, the
terminal prints a line like `"GET / HTTP/1.1" 200`. That's normal, not an
error.

To stop the server, click in the terminal and press `Ctrl+C`.

Use `localhost`, not the `0.0.0.0` address the terminal shows. If the page
doesn't load, open the **Ports** tab next to the Terminal tab and check that
port `8000` is listed; if not, click **Forward a Port** and type `8000`.

### 2. How to play

You are the `@`. Move with the **arrow keys**.

The right side of the screen shows the JavaScript that builds the level. Most
of it is locked; only a few lines or parts of lines can be edited. Each level
is impossible as loaded, so:

1. Read the code to see how the level is built.
2. Change the editable parts so there's a way out.
3. Press **Ctrl+5** (or click **Execute**) to run your new code and rebuild
   the level.
4. Walk to the exit.

Other keys worth knowing. Each one also has a button under the editor:

| Key | What it does |
| --- | --- |
| `Ctrl+1` | show the commands you've learned (the API reference) |
| `Ctrl+2` | switch between the map and the code editor |
| `Ctrl+3` | open a notepad for your own notes |
| `Ctrl+4` | reset the level's code to how it started |
| `Ctrl+5` | run your code |
| `Ctrl+0` | open the menu, including the level list |

If a shortcut switches browser tabs instead, click the matching button.

Your progress is saved in your browser, so you can close the tab and come
back later. Using a different browser, or a private window, starts fresh.

### 3. All levels are unlocked

`make` builds the game in **debug mode**. That means every level is open from
the start (`Ctrl+0` → level list) and sound starts muted (turn it on with the
speaker icon above the map). You can also jump straight to a level by its
number:

```
http://localhost:8000/?lvl=5
```

Try to beat them in order anyway: each level introduces a new command that
later levels expect you to know.

### 4. Find your way around

You don't need to touch these files to play, but they're how the game works:

| Folder / file | What it's for |
| --- | --- |
| `levels/` | **every level, one `.jsx` file each**; `levels/bonus/` has extra fan-made levels |
| `scripts/` | the game engine: map, player, objects, code editor |
| `scripts/build/untrusted.js` | everything above merged into one file by `make`; don't edit it |
| `solutions/` | **spoilers**: one way to solve each level |
| `music/`, `sound/` | the soundtrack and sound effects |
| `.devcontainer/devcontainer.json` | tells VS Code which container to build and to run `make` |

### 5. Make your own level

Levels are JavaScript with a few extra markers. The easiest start is to copy
an existing one:

1. Copy `levels/bonus/_sampleLevel.jsx` to `levels/bonus/myLevel.jsx`.
2. Change the map. The code between `#BEGIN_EDITABLE#` and `#END_EDITABLE#`
   is what the player will be allowed to change.
3. Rebuild and reload:

   ```bash
   make
   ```

   Then hard-refresh the browser (`Ctrl+Shift+R`, or `Cmd+Shift+R` on Mac).
4. Open the menu (`Ctrl+0`). Your level is in the bonus level list.

The markers are explained under **The .jsx file format** in
[`UPSTREAM_README.md`](UPSTREAM_README.md#the-jsx-file-format).

Run `make` again after any change in `levels/` or `scripts/`.

### 6. Save your work to GitHub

Your files live in the `untrusted` folder on your own computer, so they're
safe even if the container is deleted or rebuilt. To save a change to GitHub:

```bash
git add .
git commit -m "Describe what you changed"
git push
```

To push, the repo has to be yours. If you cloned someone else's copy, create
an empty repo on GitHub (no README) and point your folder at it first:

```bash
git remote set-url origin https://github.com/YOUR-USERNAME/untrusted.git
git push -u origin master
```

### 7. Leave the container

Stop the server with `Ctrl+C`, then click the **Dev Container** box in the
bottom-left corner and choose **Reopen Folder Locally**. The container stops
on its own shortly after.

---

## Instructor notes

The container is `mcr.microsoft.com/devcontainers/python:3.12`. Python serves
the files and the image already has `make`, `bash` and `sed`, which the build
needs. Nothing else is installed.

Changes from the upstream repo, all so it works the same on every machine:

- **`.gitattributes`** checks every file out with LF line endings. Without it,
  Git on Windows converts the build scripts and levels to CRLF and `make` fails
  inside the Linux container.
- **The build reads `levels/` directly.** Upstream points `mods/default` at
  `levels/` with a symlink, which Git on Windows checks out as a plain text
  file unless symlinks are enabled. `Makefile`, `compile_levels.sh` and
  `parse_target.sh` now use `levels/` for the default game. `make mod=<name>`
  still builds the mods in `mods/`. The `Makefile` also runs both scripts
  with `bash`, so it doesn't depend on their executable permission.
- **Google Analytics removed** from `index.html`, so students' play isn't
  reported to the original authors' analytics account.

`make release` (the minified build without debug features) needs Java, which
the container doesn't have. Debug mode is fine for class: it only unlocks the
levels and mutes sound by default.

`solutions/` has a solution for every level. Tell students it's there so they
know to avoid it, or delete it in your copy if you'd rather they not see it.

---

## Credits

- **Untrusted** is by [Alex Nisnevich](http://alex.nisnevich.com/) and
  [Greg Shuflin](https://github.com/neunenak), with the help of the people
  listed in [`UPSTREAM_README.md`](UPSTREAM_README.md#acknowledgements).
- **Soundtrack:** each track's artist and license is listed in
  [`UPSTREAM_README.md`](UPSTREAM_README.md#soundtrack).
- **License:** Untrusted and its soundtrack are licensed under
  [CC BY-NC-SA 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/). You may
  use and change it for non-commercial purposes, such as teaching, as long as
  you credit the authors and share your changes under the same license. This
  repo is shared under that license too. Full details are in
  [`UPSTREAM_README.md`](UPSTREAM_README.md#license); keep that file in the
  repo.
