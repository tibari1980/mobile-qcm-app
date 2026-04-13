# Remotion Video - Professional Simulation Engine

Design and render high-fidelity, React-based video simulations for professional use cases like the French naturalization interview.

## Core Capabilities
- **React-to-MP4**: Leverage React components and hooks (`useCurrentFrame`, `interpolate`) to define frame-by-frame animations.
- **Lip-Sync & Audio**: Precise synchronization with TTS (Text-to-Speech) audio tracks.
- **Dynamic Data**: Inject JSON datasets to generate hundreds of variants from a single composition.

## Project Structure
A Remotion project should be kept separate from the main application to avoid dependency conflicts.
- `src/`: Contains React components (`Agent.tsx`, `Candidate.tsx`, `Dialogue.tsx`).
- `remotion.config.ts`: Rendering and composition settings (1080p, 30fps).
- `package.json`: Independent `remotion` and `react` dependencies.

## Key Hooks
- `useCurrentFrame()`: Returns the current frame of the animation.
- `useVideoConfig()`: Returns width, height, fps, and duration.
- `interpolate(frame, [start, end], [v_start, v_end])`: For smooth transitions.

## Commands
- **Preview**: `npm start` (Opens Remotion Studio)
- **Render**: `npx remotion render <composition-id> out/video.mp4`

## Professional Guidelines
1. **Pacing**: Maintain a "formal" dialogue pace (2.5 - 3.5 words per second).
2. **Branding**: Use consistent tricolor accents (Blue/White/Red) for French official simulations.
3. **Audio Quality**: Essential for simulations. Use high-quality TTS voices.
