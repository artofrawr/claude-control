# claude-control

Opinionated config and project initialization for Claude Code. Spec and test-driven, AI-native.

## Quick Start

```bash
# Clone and install
git clone https://github.com/artofrawr/claude-control.git ~/.claude-control
cd ~/.claude-control && ./install.sh

# In any project directory
claude
> /initialize-project
```

Claude will:

1. **Validate tools** - Check gh, vercel, supabase CLIs
2. **Ask questions** - Language, framework, AI-first?, database
3. **Set up repository** - Create or connect GitHub repo
4. **Create structure** - Skills, security, CI/CD, specs, todos
5. **Prompt for specs** - Transition to defining first feature

## Skills Included (1 Skill)

### Core Skills

| Skill  | Purpose                                                     |
| ------ | ----------------------------------------------------------- |
| `base` | Universal patterns, constraints, TDD workflow, atomic todos |
