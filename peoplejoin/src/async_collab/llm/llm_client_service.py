from enum import Enum
import os
from openai import OpenAI
from src.async_collab.llm.llm_client import LLMClient


class LLMModelName(Enum):
    dev_gpt_4o_2024_05_13 = "dev-gpt-4o-2024-05-13"


class MyLLMClient(LLMClient):
    def __init__(self, model: str = "Qwen/Qwen2.5-7B-Instruct"):
        self.model = model
        self.client = OpenAI(
            api_key="dummy",
            base_url=os.environ.get("OPENAI_BASE_URL", "http://localhost:8000/v1")
        )

    def send_request(self, request, model) -> dict:
        return self.client.chat.completions.create(model=model, **request)

    def get_response_str(
        self,
        user_prompt: str,
        temperature: float = 0,
        max_tokens: int = 800,
        top_p: float = 0.95,
        system_instruction: str = "Complete user request",
        stop: str | None = None,
        model: str | None = None,
    ) -> str | None:
        if model is None:
            model = self.model
        try:
            messages = []
            if len(system_instruction) > 0:
                messages.append({"role": "system", "content": system_instruction})
            messages.append({"role": "user", "content": user_prompt})

            response = self.client.chat.completions.create(
                model=model,
                messages=messages,
                temperature=temperature,
                max_tokens=max_tokens,
                top_p=top_p,
                stop=stop,
            )

            if response.choices and len(response.choices) > 0:
                return response.choices[0].message.content
            else:
                print("[MyLLMClient] No choices in response")
                return None
        except Exception as e:
            print(f"[MyLLMClient] Exception: {e}")
            return None


llm_client: LLMClient | None = None


def get_llm_client(model) -> LLMClient:
    global llm_client
    if llm_client is None or llm_client.model != model:
        llm_client = MyLLMClient(model=model)
    return llm_client
